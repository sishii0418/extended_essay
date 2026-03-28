// Dynare script for inflation dynamics model
// EXTENSION: Real wage rigidity (benchmark before Search & Matching)
//
// Motivation:
//   Brexit-induced labour shortages created historically tight UK labour
//   market (BoE MPC, 2022: "unprecedented tightness in modern UK data").
//   Labour hoarding and search frictions imply real wages do not fully
//   adjust to their flexible equilibrium each period.
//   Following Gagliardone and Gertler (2025), real wage rigidity is
//   parsimoniously captured by a single parameter psi_w.
//
// Change from baseline (inflation.mod):
//   REMOVED:
//     rwage = (1/intsub)*gdp + (1/frisch)*employ   [flexible wage]
//   REPLACED BY:
//     rwage = psi_w*rwage(-1) + (1-psi_w)*rwage_flex
//     rwage_flex = (1/intsub)*gdp + (1/frisch)*employ
//
//   Interpretation:
//     psi_w = 0     -> fully flexible wages (baseline)
//     psi_w = 0.705 -> Gagliardone-Gertler (2025) estimate
//     psi_w -> 1    -> fully rigid real wages
//
//   With psi_w > 0, the real wage adjusts only gradually towards its
//   flexible equilibrium. This dampens the offsetting wage adjustment
//   in response to an energy price shock, keeping real marginal cost
//   (rmc = rwage + alph*tot) elevated for longer -> inflation persistence.

// -----------------------------------------------------------------------
// Variables (same as baseline + rwage_flex as auxiliary)
// -----------------------------------------------------------------------
var infl cpi resetprice gdp employ nomint rwage rwage_flex rmc nmc tot;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, theta, psi_w, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;    // Energy share of total cost
rbar   = 2;       // Steady-state real interest rate (annual %)
intsub = 0.5;     // Elasticity of intertemporal substitution
frisch = 3;       // Frisch elasticity of labour supply
theta  = 11/12;   // Calvo price stickiness
psi_w  = 0.705;   // Degree of real wage rigidity
                  // Source: Gagliardone & Gertler (2025) estimate
                  // psi_w=0 replicates baseline; psi_w=0.705 is benchmark
phi    = 0.9;     // Interest-rate smoothing
chipi  = 3;       // Taylor rule: inflation response
chiy   = 0.5;     // Taylor rule: GDP response
rho    = 0.8;     // Persistence of terms-of-trade shock

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

// IS equation and monetary policy (unchanged)
gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot    = rho*tot(-1) + totsh;

// --- Real wage rigidity (replaces flexible wage condition) ---

// Flexible-wage benchmark (what wage would be under full flexibility)
rwage_flex = (1/intsub)*gdp + (1/frisch)*employ;

// Partial adjustment: real wage moves fraction (1-psi_w) toward flex wage
// psi_w=0 -> rwage = rwage_flex (baseline)
// psi_w=0.705 -> Gagliardone-Gertler benchmark
rwage = psi_w*rwage(-1) + (1-psi_w)*rwage_flex;

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint rwage;
