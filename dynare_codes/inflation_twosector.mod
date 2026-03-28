// Dynare script for inflation dynamics model
// EXTENSION: Two-sector model
//   Sector E  (energy-using, weight omega):    Taylor pricing n=12
//   Sector NE (labour-only,  weight 1-omega):  Calvo pricing theta=11/12
//
// Motivation:
//   Energy-using firms (manufacturing, transport, agriculture) face volatile
//   costs and revise prices on annual contract cycles -> Taylor n=12
//   Service/non-energy firms have stable labour-only costs and set prices
//   more sporadically -> Calvo theta=11/12
//
// Key changes from baseline:
//   - Separate price levels cpi_e, cpi_ne and marginal costs rmc_e, rmc_ne
//   - Aggregate CPI: cpi = omega*cpi_e + (1-omega)*cpi_ne
//   - Aggregate production: gdp = employ - omega*alph*tot
//     (only E sector uses energy, so energy term scaled by omega)
//   - Flexible wages (unchanged in form, but employ now covers both sectors)

// -----------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------
var infl cpi cpi_e cpi_ne
    resetprice_e resetprice_ne
    gdp employ nomint rwage
    rmc_e rmc_ne nmc_e nmc_ne
    tot
    z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, omega, theta, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;    // Energy share in E-sector production costs
omega  = 0.30;    // Weight of E sector in CPI (energy-intensive sectors)
rbar   = 2;       // Steady-state real interest rate (annual %)
intsub = 0.5;     // Elasticity of intertemporal substitution
frisch = 3;       // Frisch elasticity of labour supply
theta  = 11/12;   // Calvo price stickiness for NE sector
phi    = 0.9;     // Interest-rate smoothing
chipi  = 3;       // Taylor rule: inflation response
chiy   = 0.5;     // Taylor rule: GDP response
rho    = 0.8;     // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model
// -----------------------------------------------------------------------
model(linear);

// --- Aggregation ---

// Aggregate CPI
cpi  = omega*cpi_e + (1-omega)*cpi_ne;

// Annualised aggregate CPI inflation
infl = 12*(cpi - cpi(-1));

// Aggregate production function
// E sector:  y^E = L^E - alph*tot
// NE sector: y^NE = L^NE
// Aggregate: gdp = omega*y^E + (1-omega)*y^NE = employ - omega*alph*tot
gdp = employ - omega*alph*tot;

// --- Marginal costs ---

// E sector: uses labour AND energy
rmc_e = rwage + alph*tot;
nmc_e = rmc_e + cpi;

// NE sector: uses labour ONLY
rmc_ne = rwage;
nmc_ne = rmc_ne + cpi;

// --- Flexible wage (common labour market) ---
rwage = (1/intsub)*gdp + (1/frisch)*employ;

// --- Demand and monetary policy (unchanged from baseline) ---
gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot    = rho*tot(-1) + totsh;

// -----------------------------------------------------------------------
// E sector: Taylor pricing (n=12)
// -----------------------------------------------------------------------

// Forward auxiliary variables using nmc_e:
// z_k = sum_{j=0}^{k-1} bet^j * E_t[nmc_e_{t+j}]
z2  = nmc_e + bet*nmc_e(+1);
z3  = nmc_e + bet*z2(+1);
z4  = nmc_e + bet*z3(+1);
z5  = nmc_e + bet*z4(+1);
z6  = nmc_e + bet*z5(+1);
z7  = nmc_e + bet*z6(+1);
z8  = nmc_e + bet*z7(+1);
z9  = nmc_e + bet*z8(+1);
z10 = nmc_e + bet*z9(+1);
z11 = nmc_e + bet*z10(+1);
z12 = nmc_e + bet*z11(+1);

// Optimal reset price: PV-weighted avg of nmc_e over n=12 contract
resetprice_e = ((1-bet)/(1-bet^12)) * z12;

// E-sector CPI = equally-weighted avg of last 12 reset prices
cpi_e = (1/12)*(resetprice_e       + resetprice_e(-1)  + resetprice_e(-2)
              + resetprice_e(-3)   + resetprice_e(-4)  + resetprice_e(-5)
              + resetprice_e(-6)   + resetprice_e(-7)  + resetprice_e(-8)
              + resetprice_e(-9)   + resetprice_e(-10) + resetprice_e(-11));

// -----------------------------------------------------------------------
// NE sector: Calvo pricing (theta = 11/12)
// -----------------------------------------------------------------------
cpi_ne      = theta*cpi_ne(-1) + (1-theta)*resetprice_ne;
resetprice_ne = bet*theta*resetprice_ne(+1) + (1-bet*theta)*nmc_ne;

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=100, order=1) infl gdp tot nomint cpi_e cpi_ne;
