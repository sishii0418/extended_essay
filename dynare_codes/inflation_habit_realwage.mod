// Dynare script for inflation dynamics model
// EXTENSION: Real wage rigidity + Habit formation in consumption
//
// Motivation:
//   (1) Real wage rigidity (psi_w = 0.705):
//       Brexit-induced labour shortages created historically tight UK labour
//       market. Labour hoarding and search frictions imply real wages do not
//       fully adjust each period.
//       Source: Gagliardone & Gertler (2025), estimated psi_w = 0.705.
//
//   (2) Habit formation (h = 0.74, quarterly value from G&G):
//       Consumers maintain consumption habits relative to previous period,
//       generating hump-shaped output dynamics and backward-looking component
//       in the IS curve. This slows the response of demand to shocks and
//       sustains cost pressures on firms for longer.
//       Source: Gagliardone & Gertler (2025), estimated h = 0.906 (monthly),
//               equivalent to h = 0.74 quarterly. We use h = 0.74 for our
//               monthly model as a conservative calibration.
//
// Changes from baseline (inflation.mod):
//   (1) Real wage rigidity:
//       REMOVED:  rwage = (1/intsub)*gdp + (1/frisch)*employ
//       REPLACED: rwage_flex = (1/intsub)*gdp + (1/frisch)*employ
//                 rwage = psi_w*rwage(-1) + (1-psi_w)*rwage_flex
//
//   (2) Habit formation:
//       REMOVED:  gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12))
//       REPLACED: gdp = (h/(1+h))*gdp(-1) + (1/(1+h))*gdp(+1)
//                     - ((1-h)/(intsub*(1+h)))*((nomint/12) - (infl(+1)/12))
//
//       Derivation: with U = ln(C_t - h*C_{t-1}), the Euler equation becomes
//       C_t - h*C_{t-1} = E_t[C_{t+1} - h*C_t] - (1-h)/sigma * (i_t - pi_{t+1})
//       Rearranging gives the IS curve above, where h=0 replicates baseline.

// -----------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------
var infl cpi resetprice gdp employ nomint rwage rwage_flex rmc nmc tot;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, theta, psi_w, h, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;   // Energy share of total cost
rbar   = 2;      // Steady-state real interest rate (annual %)
intsub = 0.5;    // Elasticity of intertemporal substitution
frisch = 3;      // Frisch elasticity of labour supply
theta  = 11/12;  // Calvo price stickiness
psi_w  = 0.705;  // Degree of real wage rigidity
                 // Source: Gagliardone & Gertler (2025)
h      = 0.74;   // Habit formation parameter
                 // Source: Gagliardone & Gertler (2025) quarterly estimate
                 // h=0 replicates baseline IS curve
phi    = 0.9;    // Interest-rate smoothing
chipi  = 3;      // Taylor rule: inflation response
chiy   = 0.5;    // Taylor rule: GDP response
rho    = 0.8;    // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model
// -----------------------------------------------------------------------
model(linear);

// --- Unchanged from baseline ---
gdp  = employ - alph*tot;          // Aggregate production function
rmc  = rwage + alph*tot;           // Real marginal cost
nmc  = rmc + cpi;                  // Nominal marginal cost
infl = 12*(cpi - cpi(-1));         // Annualised CPI inflation

// Calvo price setting (unchanged)
cpi        = theta*cpi(-1) + (1-theta)*resetprice;
resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc;

// Taylor rule (unchanged)
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// Terms of trade (unchanged)
tot = rho*tot(-1) + totsh;

// --- Extension 1: Real wage rigidity ---

// Flexible-wage benchmark
rwage_flex = (1/intsub)*gdp + (1/frisch)*employ;

// Partial adjustment toward flexible wage
// h=0 -> rwage = rwage_flex (baseline)
rwage = psi_w*rwage(-1) + (1-psi_w)*rwage_flex;

// --- Extension 2: Habit formation in IS curve ---
// Standard IS: gdp = gdp(+1) - intsub*(r)
// With habits: gdp = h/(1+h)*gdp(-1) + 1/(1+h)*gdp(+1)
//                  - (1-h)/(intsub*(1+h))*(nomint/12 - infl(+1)/12)
// h=0 replicates baseline IS curve exactly
gdp = (h/(1+h))*gdp(-1) + (1/(1+h))*gdp(+1)
    - ((1-h)/(intsub*(1+h)))*((nomint/12) - (infl(+1)/12));

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint rwage;
