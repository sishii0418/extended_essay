// Dynare script for inflation dynamics model
// EXTENSION: Calvo nominal wage rigidity (Erceg, Henderson and Levin, 2001)
//
// Changes from baseline (inflation.mod):
//   REMOVED: rwage = (1/intsub)*gdp + (1/frisch)*employ  [flexible wage condition]
//   ADDED:   3 new variables: nwage, winfl, resetwage
//   ADDED:   4 new equations (see below)
//
// New variables:
//   nwage     = nominal wage (log deviation)
//   winfl     = annualised nominal wage inflation
//   resetwage = optimal reset wage chosen by adjusting households
//
// New equations:
//   (i)   rwage = nwage - cpi                               [real wage definition]
//   (ii)  winfl = 12*(nwage - nwage(-1))                    [wage inflation definition]
//   (iii) nwage = thetaw*nwage(-1) + (1-thetaw)*resetwage   [Calvo wage index]
//   (iv)  resetwage = bet*thetaw*resetwage(+1)
//                   + (1-bet*thetaw)*(cpi + (1/intsub)*gdp + (1/frisch)*employ)
//                                                            [optimal reset wage = nominal MRS]
//
// Intuition for (iv):
//   The nominal MRS = p_t + (1/sigma)*y_t + (1/psi)*L_t is the household's
//   reservation wage in nominal terms. An adjusting household sets resetwage
//   as a PV-weighted average of expected future nominal MRS over the duration
//   the reset wage will remain fixed (Calvo probability thetaw).

// -----------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot
    nwage winfl resetwage;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, theta, thetaw, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;    // Energy share of total cost
rbar   = 2;       // Steady-state real interest rate (annual %)
intsub = 0.5;     // Elasticity of intertemporal substitution (sigma)
frisch = 3;       // Frisch elasticity of labour supply (psi)
theta  = 11/12;   // Calvo price stickiness (avg duration 12 months)
thetaw = 0.93;    // Calvo wage stickiness  (avg duration ~14 months)
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
gdp  = employ - alph*tot;           // Aggregate production function
rmc  = rwage + alph*tot;            // Real marginal cost
nmc  = rmc + cpi;                   // Nominal marginal cost
infl = 12*(cpi - cpi(-1));          // Annualised CPI inflation

// Calvo price setting (unchanged)
cpi        = theta*cpi(-1) + (1-theta)*resetprice;
resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc;

// Demand and monetary policy (unchanged)
gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot    = rho*tot(-1) + totsh;

// --- New: Calvo nominal wage rigidity ---

// (i) Real wage definition (replaces flexible wage condition)
rwage = nwage - cpi;

// (ii) Annualised nominal wage inflation
winfl = 12*(nwage - nwage(-1));

// (iii) Calvo nominal wage index
nwage = thetaw*nwage(-1) + (1-thetaw)*resetwage;

// (iv) Optimal reset wage = PV-weighted avg of nominal MRS
//      Nominal MRS = cpi + (1/intsub)*gdp + (1/frisch)*employ
resetwage = bet*thetaw*resetwage(+1)
            + (1-bet*thetaw)*(cpi + (1/intsub)*gdp + (1/frisch)*employ);

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=48, order=1) infl gdp tot nomint winfl;
