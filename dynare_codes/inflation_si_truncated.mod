// Dynare script for inflation dynamics model
// EXTENSION: Sticky Information pricing (Mankiw & Reis, 2002, QJE)
//            Truncated sum approximation (J=12 months)
//
// Reference:
//   Mankiw, N.G. and Reis, R. (2002), "Sticky Information versus Sticky
//   Prices: A Proposal to Replace the New Keynesian Phillips Curve",
//   Quarterly Journal of Economics, 117(4), pp. 1295-1328.
//
// Truncated sum approximation:
//   Exact SI: cpi_t = (1-lambda) * Sigma_{j=0}^inf lambda^j * E_{t-j}[nmc_t]
//   Truncated: cpi_t = [(1-lambda)/(1-lambda^13)]
//                      * Sigma_{j=0}^{12} lambda^j * E_{t-j}[nmc_t]
//
//   where E_{t-j}[nmc_t] = hj_{t-j} = hj(-j) in Dynare notation
//   and hk_t = E_t[nmc_{t+k}], defined recursively:
//     h1 = nmc(+1)
//     hk = h{k-1}(+1)   (law of iterated expectations)
//
//   Renormalisation (1-lambda)/(1-lambda^13) ensures weights sum to 1.
//   Truncation error for lambda=0.91, J=12: lambda^13 ≈ 0.30 -> ~3% error.
//
// Advantage over KW approximation:
//   KW is accurate only when nmc ≈ random walk (rho close to 1).
//   Truncated sum is valid for any rho, including baseline rho=0.8.
//   With rho=0.8, non-updating firms correctly reflect that future nmc
//   will be lower, but the weighted average still creates persistence
//   because old information (from periods t-1 to t-12) is reflected.
//
// Parameter calibration:
//   lambda = 0.91 (monthly), from Mankiw-Reis (2002) lambda_Q=0.75.
//
// Changes from baseline (inflation.mod):
//   REMOVED: resetprice, 2 Calvo equations
//   ADDED:   h1,...,h12 (12 aux vars), SI CPI equation, 12 forecast eqs
//   Variable count: 10 - 1 + 12 = 21
//   Equation count: 10 - 2 + 1 + 12 = 21

// -----------------------------------------------------------------------
// Variables (21)
// -----------------------------------------------------------------------
var infl cpi gdp employ nomint rwage rmc nmc tot
    h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, lambda_si, intsub, frisch, phi, chipi, chiy, rho;

alph      = 0.15;
rbar      = 2;
intsub    = 0.5;
frisch    = 3;
lambda_si = 0.91;
phi       = 0.9;
chipi     = 3;
chiy      = 0.5;
rho       = 0.95;    // Baseline value; truncated sum valid for any rho

bet = (1/(1+(rbar/100)))^(1/12);

// -----------------------------------------------------------------------
// Model (21 equations)
// -----------------------------------------------------------------------
model(linear);

// --- Unchanged from baseline ---
gdp   = employ - alph*tot;
rmc   = rwage + alph*tot;
nmc   = rmc + cpi;
rwage = (1/intsub)*gdp + (1/frisch)*employ;
infl  = 12*(cpi - cpi(-1));
gdp   = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot   = rho*tot(-1) + totsh;

// --- Sticky Information: truncated sum (J=12) ---

// Forecast auxiliary variables:
// hk_t = E_t[nmc_{t+k}] (k-period-ahead expectation of nmc from period t)
// Recursive: hk_t = E_t[h{k-1}_{t+1}] -> hk = h{k-1}(+1) in Dynare
// h1(-1) = E_{t-1}[nmc_t], h2(-2) = E_{t-2}[nmc_t], etc.
h1  = nmc(+1);
h2  = h1(+1);
h3  = h2(+1);
h4  = h3(+1);
h5  = h4(+1);
h6  = h5(+1);
h7  = h6(+1);
h8  = h7(+1);
h9  = h8(+1);
h10 = h9(+1);
h11 = h10(+1);
h12 = h11(+1);

// SI CPI equation (truncated at J=12, renormalised):
// cpi_t = [(1-lambda)/(1-lambda^13)]
//         * [nmc_t                      (j=0: current info)
//          + lambda   * h1(-1)          (j=1: 1-period old info)
//          + lambda^2 * h2(-2)          (j=2: 2-period old info)
//          + ...
//          + lambda^12 * h12(-12)]      (j=12: 12-period old info)
cpi = ((1-lambda_si)/(1-lambda_si^13))*(
        nmc
      + lambda_si    * h1(-1)
      + lambda_si^2  * h2(-2)
      + lambda_si^3  * h3(-3)
      + lambda_si^4  * h4(-4)
      + lambda_si^5  * h5(-5)
      + lambda_si^6  * h6(-6)
      + lambda_si^7  * h7(-7)
      + lambda_si^8  * h8(-8)
      + lambda_si^9  * h9(-9)
      + lambda_si^10 * h10(-10)
      + lambda_si^11 * h11(-11)
      + lambda_si^12 * h12(-12));

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=50, order=1) infl gdp tot nomint;

// -----------------------------------------------------------------------
// Post-simulation: fraction of initial shock remaining each period
// -----------------------------------------------------------------------

irf_infl = oo_.irfs.infl_totsh;
irf_tot  = oo_.irfs.tot_totsh;
periods  = 1:50;

% 初期値（t=1のIRF）で正規化
init_infl = irf_infl(1);
init_tot  = irf_tot(1);

frac_infl = irf_infl / init_infl;
frac_tot  = irf_tot  / init_tot;

% --- 数値出力 ---
fprintf('\n=== Fraction of initial shock remaining ===\n');
fprintf('%6s  %10s  %10s\n', 'Period', 'infl', 'tot');
for t = 1:50
    fprintf('%6d  %10.4f  %10.4f\n', t, frac_infl(t), frac_tot(t));
end

% --- プロット ---
figure;
plot(periods, frac_infl, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(periods, frac_tot,  'r--s', 'LineWidth', 1.5, 'MarkerSize', 4);
yline(1, 'k:');
yline(0, 'k-');

xlabel('Months after shock');
ylabel('Fraction of t=1 response remaining');
title('Shock persistence: infl vs tot (Sticky Information)');
legend('infl', 'tot', 'Location', 'northeast');
grid on;