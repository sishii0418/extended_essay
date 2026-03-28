// Dynare script for inflation dynamics model
// EXTENSION: Taylor goods pricing (n=12) + Calvo nominal wage rigidity
//
// Motivation:
//   - Taylor goods pricing (n=12): annual price-setting cycles are common
//     in UK (insurance, rents, supply contracts). n=12 is also directly
//     comparable to Calvo baseline with theta=11/12 (same avg duration).
//   - Calvo wages (thetaw=0.93): wage renegotiation is staggered and
//     probabilistic across firms; avg duration ~14 months.
//
// Changes from baseline (inflation.mod):
//   REMOVED:
//     - theta (Calvo price prob.)
//     - cpi = theta*cpi(-1) + (1-theta)*resetprice
//     - resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc
//     - rwage = (1/intsub)*gdp + (1/frisch)*employ  [flexible wage]
//
//   ADDED (Taylor pricing, n=12):
//     - Auxiliary variables z2...z12 for forward NMC sum
//     - cpi = (1/12)*sum_{k=0}^{11} resetprice(-k)
//     - resetprice = [(1-bet)/(1-bet^12)] * z12
//
//   ADDED (Calvo wage rigidity):
//     - Variables: nwage, winfl, resetwage
//     - rwage    = nwage - cpi
//     - winfl    = 12*(nwage - nwage(-1))
//     - nwage    = thetaw*nwage(-1) + (1-thetaw)*resetwage
//     - resetwage = bet*thetaw*resetwage(+1)
//                 + (1-bet*thetaw)*(cpi + (1/intsub)*gdp + (1/frisch)*employ)

// -----------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot
    z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12
    nwage winfl resetwage;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, thetaw, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;   // Energy share of total cost
rbar   = 2;      // Steady-state real interest rate (annual %)
intsub = 0.5;    // Elasticity of intertemporal substitution
frisch = 3;      // Frisch elasticity of labour supply
thetaw = 0.93;   // Calvo wage stickiness (avg duration ~14 months)
phi    = 0.9;    // Interest-rate smoothing
chipi  = 3;      // Taylor rule: inflation response
chiy   = 0.5;    // Taylor rule: GDP response
rho    = 0.8;    // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

model(linear);

// -----------------------------------------------------------------------
// Unchanged from baseline
// -----------------------------------------------------------------------
gdp  = employ - alph*tot;
rmc  = rwage + alph*tot;
nmc  = rmc + cpi;
infl = 12*(cpi - cpi(-1));

gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot    = rho*tot(-1) + totsh;

// -----------------------------------------------------------------------
// Taylor goods pricing block (n=12)
// -----------------------------------------------------------------------

// Forward auxiliary variables (one lead per equation):
// z_k = sum_{j=0}^{k-1} bet^j * E_t[nmc_{t+j}]
z2  = nmc + bet*nmc(+1);
z3  = nmc + bet*z2(+1);
z4  = nmc + bet*z3(+1);
z5  = nmc + bet*z4(+1);
z6  = nmc + bet*z5(+1);
z7  = nmc + bet*z6(+1);
z8  = nmc + bet*z7(+1);
z9  = nmc + bet*z8(+1);
z10 = nmc + bet*z9(+1);
z11 = nmc + bet*z10(+1);
z12 = nmc + bet*z11(+1);

// Optimal reset price: PV-weighted avg of NMC over n=12 contract
resetprice = ((1-bet)/(1-bet^12)) * z12;

// CPI = equally-weighted avg of last 12 reset prices
cpi = (1/12)*(resetprice      + resetprice(-1)  + resetprice(-2)
            + resetprice(-3)  + resetprice(-4)  + resetprice(-5)
            + resetprice(-6)  + resetprice(-7)  + resetprice(-8)
            + resetprice(-9)  + resetprice(-10) + resetprice(-11));

// -----------------------------------------------------------------------
// Calvo nominal wage rigidity block
// -----------------------------------------------------------------------

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

shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint winfl;
