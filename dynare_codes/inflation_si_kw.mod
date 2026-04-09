// Dynare script for inflation dynamics model
// EXTENSION: Sticky Information pricing (Mankiw & Reis, 2002, QJE)
//            Klenow-Willis (2007) recursive approximation
//
// Reference:
//   Mankiw, N.G. and Reis, R. (2002), "Sticky Information versus Sticky
//   Prices: A Proposal to Replace the New Keynesian Phillips Curve",
//   Quarterly Journal of Economics, 117(4), pp. 1295-1328.
//
// Key difference from Calvo (baseline):
//   Calvo:  PRICES are sticky. Firms that cannot adjust keep price fixed.
//           Firms that do adjust use current-period information.
//           -> NKPC is purely forward-looking: pi_t = beta*E_t[pi_{t+1}] + kappa*mc_t
//
//   SI:     INFORMATION is sticky. All firms can adjust prices each period,
//           but only fraction (1-lambda) update their information set.
//           Remaining fraction lambda price based on outdated information.
//           -> NKPC is purely backward-looking:
//              pi_t proportional to Sigma lambda^j * E_{t-1-j}[pi_t + ...]
//
// Klenow-Willis (2007) recursive approximation:
//   Exact SI: cpi_t = (1-lambda) * Sigma_{j=0}^inf lambda^j * E_{t-j}[nmc_t]
//   KW approx: cpi_t = (1-lambda)*nmc_t + lambda*(cpi_{t-1} + E_{t-1}[Δnmc_t])
//   where E_{t-1}[Δnmc_t] = h1(-1) - nmc(-1), and h1_t = E_t[nmc_{t+1}]
//
//   Approximation error: lambda^2*(1-lambda)*Sigma_{j>=2} E_{t-j}[Δnmc_t]
//   Error is small when nmc is close to a random walk (rho close to 1).
//   For rho=0.95: E_{t-1}[Δnmc_t] = -0.05*nmc_{t-1} (small correction)
//
// Parameter calibration:
//   lambda = 0.91 (monthly)
//   Source: Mankiw-Reis (2002) estimate lambda_Q = 0.75 (quarterly)
//           Converted to monthly: lambda_M = 0.75^(1/3) ≈ 0.91
//           Average information update interval: 1/(1-0.91) ≈ 11 months
//           Comparable to Calvo theta=11/12 (avg price duration 12 months)
//
// Changes from baseline (inflation.mod):
//   REMOVED:
//     resetprice variable
//     cpi = theta*cpi(-1) + (1-theta)*resetprice       [Calvo CPI]
//     resetprice = bet*theta*resetprice(+1) + ...       [Calvo reset price]
//   ADDED:
//     h1 variable
//     h1  = nmc(+1)                                    [1-period forecast]
//     cpi = (1-lambda_si)*nmc
//           + lambda_si*(cpi(-1) + h1(-1) - nmc(-1))  [KW-SI CPI]
//
//   Variable count: 10 - 1(resetprice) + 1(h1) = 10
//   Equation count: 10 - 2(Calvo) + 2(SI+forecast) = 10

// -----------------------------------------------------------------------
// Variables (10)
// -----------------------------------------------------------------------
var infl cpi gdp employ nomint rwage rmc nmc tot h1;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, lambda_si, intsub, frisch, phi, chipi, chiy, rho;

alph      = 0.15;   // Energy share of total cost (Leontief)
rbar      = 2;      // Steady-state real interest rate (annual %)
intsub    = 0.5;    // Elasticity of intertemporal substitution
frisch    = 3;      // Frisch elasticity of labour supply
lambda_si = 0.91;   // Fraction NOT updating information each period
                    // Mankiw-Reis (2002): lambda_Q=0.75 -> lambda_M=0.91
phi       = 0.9;    // Interest-rate smoothing
chipi     = 3;      // Taylor rule: inflation response
chiy      = 0.5;    // Taylor rule: GDP response
rho       = 0.95;    // Persistence of terms-of-trade shock (baseline value)

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model (10 equations)
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

// --- Sticky Information: Klenow-Willis approximation ---
// h1_t = E_t[nmc_{t+1}]: 1-period-ahead forecast of nmc
// h1(-1) = E_{t-1}[nmc_t]: used by non-updating firms this period
h1 = nmc(+1);

// KW-SI CPI:
//   (1-lambda): updating firms set price = nmc_t (current info)
//   lambda:     non-updating firms adjust last price by E_{t-1}[Δnmc_t]
//             = cpi_{t-1} + (h1(-1) - nmc(-1))
cpi = (1-lambda_si)*nmc + lambda_si*(cpi(-1) + h1(-1) - nmc(-1));

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=50, order=1) infl gdp tot nomint;
