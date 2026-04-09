// Dynare script for inflation dynamics model
// EXTENSION: Search & Matching + Real Wage Rigidity + C ≠ Y resource constraint
//
// Motivation:
//   Brexit-induced labour shortages created historically tight UK labour market.
//   Search & matching frictions make employment a stock variable, so labour
//   market recovery after a shock is gradual, sustaining cost pressure.
//   Real wage rigidity (gamma=0.705) follows Gagliardone & Gertler (2025).
//
// Key structural choice: C ≠ Y (resource constraint C = Y - c*v)
//   Vacancy posting costs c*v_t absorb real resources.
//   This allows n to have a proper law of motion while IS curve uses C.
//   GDP is defined via resource constraint: gdp = cons + cvratio*v
//   where cvratio = c*v_bar/y_bar ≈ 0.01 (calibrated from G&G 2025).
//
// Note on production function:
//   We do NOT write gdp = n - alph*tot as an explicit equation.
//   Doing so would over-determine the system (3 equations for gdp and n:
//   production function + law of motion + IS curve).
//   Instead: gdp is defined through the resource constraint (eq 8).
//   n enters through labour market dynamics (law of motion → unemployment →
//   tightness → Nash wage → rmc → inflation). rmc = rwage + alph*tot
//   does not require n explicitly (Leontief cost structure).
//   This follows Blanchard & Gali (2010)'s tractable formulation of S&M.
//
// Variables (16):
//   Price block:    infl, cpi, resetprice, nmc, rmc, nomint
//   Output block:   gdp, cons
//   S&M block:      n, u, v, tightness, qrate, rwage, wnash
//   Exogenous:      tot
//
// Equations (16):
//   Price block (6): infl, cpi, resetprice, nmc, rmc, nomint
//   Output block (3): IS (cons), resource constraint (gdp), tot
//   S&M block (7):  u, qrate, v, n, JC, wnash, rwage

// -----------------------------------------------------------------------
// Variables (16)
// -----------------------------------------------------------------------
var infl cpi resetprice gdp cons n u v tightness qrate
    rwage wnash rmc nmc nomint tot;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, thetap, gamma, sigm, rhon, nbar, ubar, cvratio,
           intsub, phi, chipi, chiy, rho;

alph    = 0.15;   // Energy share of total cost (Leontief)
rbar    = 2;      // Steady-state real interest rate (annual %)
intsub  = 0.5;    // Elasticity of intertemporal substitution
thetap  = 11/12;  // Calvo price stickiness (avg duration 12 months)
                  // named thetap to avoid clash with tightness variable
phi     = 0.9;    // Interest-rate smoothing
chipi   = 3;      // Taylor rule: inflation response
chiy    = 0.5;    // Taylor rule: GDP response
rho     = 0.99;    // Persistence of terms-of-trade shock

// Search & Matching parameters
gamma   = 0.705;  // Real wage rigidity; Gagliardone & Gertler (2025)
sigm    = 0.5;    // Matching elasticity = worker bargaining power (Hosios)
rhon    = 0.96;   // Monthly job survival rate (~2yr avg employment duration)
nbar    = 0.95;   // Steady-state employment rate
ubar    = 0.05;   // Steady-state unemployment rate (= 1 - nbar)
cvratio = 0.01;   // Steady-state ratio of vacancy costs to output: c*v_bar/y_bar
                  // Calibrated from G&G (2025): c=0.09, vacancy rate ~0.054,
                  // implying c*v_bar/y_bar ≈ 0.01 (1% of output)

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model (16 equations)
// -----------------------------------------------------------------------
model(linear);

// =======================================================================
// BLOCK 1: Price setting (6 equations)
// =======================================================================

// Real marginal cost: Leontief technology, rmc = rwage + alph*tot
// (does not depend on n explicitly)
rmc = rwage + alph*tot;

// Nominal marginal cost
nmc = rmc + cpi;

// Annualised CPI inflation
infl = 12*(cpi - cpi(-1));

// Calvo price index (thetap = Calvo parameter, distinct from tightness)
cpi = thetap*cpi(-1) + (1-thetap)*resetprice;

// Calvo reset price
resetprice = bet*thetap*resetprice(+1) + (1-bet*thetap)*nmc;

// Taylor rule (responds to gdp = total output including vacancy costs)
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// =======================================================================
// BLOCK 2: Output and demand (3 equations)
// =======================================================================

// IS curve: Euler equation for CONSUMPTION (C, not Y)
// With C = Y - c*v, the demand side is driven by consumption dynamics
cons = cons(+1) - intsub*((nomint/12) - (infl(+1)/12));

// Resource constraint: Y_t = C_t + c*v_t
// Log-lin (C_bar ≈ Y_bar since cvratio ≈ 0.01):
// gdp = cons + cvratio*v
// This DEFINES gdp; no separate production function needed
gdp = cons + cvratio*v;

// Terms-of-trade shock (exogenous energy price)
tot = rho*tot(-1) + totsh;

// =======================================================================
// BLOCK 3: Search & Matching labour market (7 equations)
// =======================================================================

// Unemployment (log deviation from SS)
// Levels: u_t = 1 - rhon*n_{t-1} (workers searching at start of period)
// SS: ubar = 1 - rhon*nbar
// Log-lin: ubar*u_hat = -rhon*nbar*n_hat_{t-1}
u = -(rhon*nbar/ubar)*n(-1);

// Vacancy filling rate: q_t = mu*theta_t^{-sigm}
// Log-lin: qrate_hat = -sigm*tightness_hat
qrate = -sigm*tightness;

// Vacancies from tightness definition: tightness_t = v_t/u_t
// Log-lin: tightness_hat = v_hat - u_hat -> v_hat = tightness_hat + u_hat
v = tightness + u;

// Employment law of motion: n_t = rhon*n_{t-1} + q_t*v_t
// SS: nbar = rhon*nbar + q_bar*v_bar -> q_bar*v_bar = (1-rhon)*nbar
// Log-lin: n = rhon*n(-1) + (1-rhon)*(qrate + v)
n = rhon*n(-1) + (1-rhon)*(qrate + v);

// Job Creation (JC) condition (free entry into vacancy posting)
// From: c/q_t = bet*rhon*E[c/q_{t+1}] + (rmc_t - rwage_t)
// Using q_t = mu*theta_t^{-sigm} -> (c/q)_hat = sigm*tightness_hat
// Log-lin (dividing by SS surplus = (1-bet*rhon)*c/q_bar):
// sigm*tightness = (1-bet*rhon)*(rmc-rwage) + bet*rhon*sigm*tightness(+1)
sigm*tightness = (1-bet*rhon)*(rmc - rwage) + bet*rhon*sigm*tightness(+1);

// Nash bargaining wage (Hosios condition: varsigma = sigm = 0.5, b=0)
// wnash = sigm*rmc + sigm*tightness
wnash = sigm*rmc + sigm*tightness;

// Real wage rigidity: Gagliardone & Gertler (2025), eq. 15
// w_qt = (w^o_qt)^{1-gamma} * (w^o_q)^gamma
// Log-lin: rwage = (1-gamma)*wnash
// gamma=0: fully flexible Nash wage
// gamma=0.705: G&G benchmark (29.5% of Nash change passes through)
rwage = (1-gamma)*wnash;

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp cons tot nomint u tightness rwage;

// -----------------------------------------------------------------------
// Plot: infl/tot ratio (inflation persistence relative to energy shock)
// -----------------------------------------------------------------------
// Extract IRFs from oo_.irfs
infl_irf = oo_.irfs.infl_totsh;
tot_irf  = oo_.irfs.tot_totsh;
periods  = 1:24;

% Compute ratio: how large is inflation relative to tot shock each period
% Normalise both by their period-1 values so ratio starts at 1
infl_norm = infl_irf / infl_irf(1);   // infl relative to its own impact
tot_norm  = tot_irf  / tot_irf(1);    // tot relative to its own impact

figure('Name', 'Inflation vs ToT: Normalised IRFs and Ratio');

subplot(2,1,1);
plot(periods, infl_norm, 'b-',  'LineWidth', 2); hold on;
plot(periods, tot_norm,  'r--', 'LineWidth', 2);
yline(0, 'k-');
legend('infl (normalised)', 'tot (normalised)', 'Location', 'NorthEast');
title('Normalised IRFs: Inflation vs Terms of Trade');
xlabel('Months'); ylabel('Relative to period-1 value');

subplot(2,1,2);
ratio = infl_norm ./ tot_norm;
plot(periods, ratio, 'k-', 'LineWidth', 2);
yline(1, 'r--');   // ratio=1: infl decays at same rate as tot
xlabel('Months'); ylabel('infl / tot (normalised)');
title('Ratio of normalised inflation to normalised tot');
% ratio > 1: inflation MORE persistent than tot shock
% ratio = 1: inflation decays at exactly the same rate as tot
% ratio < 1: inflation decays FASTER than tot