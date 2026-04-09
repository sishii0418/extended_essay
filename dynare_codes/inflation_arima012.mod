// Dynare script for inflation dynamics model
// Baseline Calvo pricing with MA(2) energy price shock
//
// Shock process: ARIMA(0,1,2) estimated on UK natural gas price (ONS data)
//   auto.arima() in R:  θ1 = 0.2894 (se=0.059)
//                       θ2 = -0.5370 (se=0.058)
//                       σ² = 13.01
//   Δlog(tot)_t = e_t + θ1*e_{t-1} + θ2*e_{t-2}
//
// Dynare MA(2) implementation:
//   varexo cannot be lagged directly, so aux1/aux2 track lagged shocks.
//   aux1_t = e_t          -> aux1(-1) = e_{t-1}
//   aux2_t = aux1(-1)     -> aux2(-1) = e_{t-2}
//   tot_t  = e_t + θ1*aux1(-1) + θ2*aux2(-1)
//
// Everything else is identical to the baseline inflation.mod

// Endogenous variables (12 = 10 baseline + 2 MA aux)
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot aux1 aux2;

// Exogenous variables
varexo totsh;

// Parameters
parameters alph, bet, theta, intsub, frisch, phi, chipi, chiy, ma1, ma2;

alph   = 0.15;      // Energy share of total cost of production
rbar   = 2;         // Steady-state real interest rate (annual %)
intsub = 0.5;       // Elasticity of intertemporal substitution
frisch = 3;         // Frisch elasticity of labour supply
theta  = 11/12;     // Calvo probability of no price adjustment
phi    = 0.9;       // Interest-rate smoothing
chipi  = 3;         // Taylor rule: inflation response
chiy   = 0.5;       // Taylor rule: GDP response

// MA(2) coefficients: R auto.arima() on UK natural gas price (ONS)
ma1 =  0.2894;      // θ1
ma2 = -0.5370;      // θ2 (negative: price reversal after 2 months)

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

model(linear);

// --- Unchanged from baseline ---
gdp        = employ - alph*tot;
rmc        = rwage + alph*tot;
nmc        = rmc + cpi;
rwage      = (1/intsub)*gdp + (1/frisch)*employ;
infl       = 12*(cpi - cpi(-1));
cpi        = theta*cpi(-1) + (1-theta)*resetprice;
resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc;
gdp        = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint     = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// --- ARIMA(0, 1, 2) shock process (replaces AR(1) tot equation) ---
aux1 = totsh;               // current shock
aux2 = aux1(-1);            // one-period lagged shock
tot  = tot(-1) + totsh + ma1*aux1(-1) + ma2*aux2(-1);

end;

shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint;

// -----------------------------------------------------------------------
// Post-simulation: persistence comparison
// -----------------------------------------------------------------------

irf_infl = oo_.irfs.infl_totsh;
irf_tot  = oo_.irfs.tot_totsh;
periods  = 1:24;

init_infl = irf_infl(1);
init_tot  = irf_tot(1);

frac_infl = irf_infl / init_infl;
frac_tot  = irf_tot  / init_tot;

fprintf('\n=== Fraction of initial shock remaining (MA(2) baseline) ===\n');
fprintf('%6s  %10s  %10s\n', 'Period', 'infl', 'tot');
for t = 1:24
    fprintf('%6d  %10.4f  %10.4f\n', t, frac_infl(t), frac_tot(t));
end

figure;
plot(periods, frac_infl, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(periods, frac_tot, 'r--s', 'LineWidth', 1.5, 'MarkerSize', 4);
yline(0, 'k-');

xlabel('Months after shock');
ylabel('Fraction of t=1 response remaining');
title('Persistence: infl vs tot — Calvo baseline with MA(2) shock');
legend('infl', 'tot', 'Location', 'northeast');
grid on;
