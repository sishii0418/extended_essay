// Dynare script for inflation dynamics model - TAYLOR PRICING VERSION
// n = 12 period Taylor contracts
// Comparable to Calvo theta = 11/12 (same average price duration: 12 months)
//
// Key changes from Calvo version (inflation.mod):
//   1. theta parameter removed
//   2. CPI equation: average of last 12 reset prices (not Calvo recursion)
//   3. Reset price: PV-weighted avg of NMC over 12-period contract horizon
//   4. Auxiliary variables z2-z12 to handle multi-period leads (one lead per eq.)

// Endogenous variables
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot
    z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12;

// Exogenous variables
varexo totsh;

// Parameters (theta removed - not needed for Taylor pricing)
parameters alph, bet, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;  // Energy share of total cost of production
rbar   = 2;     // Steady-state real interest rate of 2% annual
intsub = 0.5;   // Elasticity of intertemporal substitution
frisch = 3;     // Frisch elasticity of labour supply
phi    = 0.9;   // Interest-rate smoothing parameter
chipi  = 3;     // Taylor-rule response to inflation
chiy   = 0.5;   // Taylor-rule response to GDP
rho    = 0.8;   // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12); // Implied monthly discount factor

model(linear);

// -----------------------------------------------------------------------
// Equations unchanged from Calvo baseline
// -----------------------------------------------------------------------
gdp    = employ - alph*tot;                         // Aggregate production function
rmc    = rwage + alph*tot;                          // Real marginal cost
nmc    = rmc + cpi;                                 // Nominal marginal cost definition
rwage  = (1/intsub)*gdp + (1/frisch)*employ;        // Labour supply curve
infl   = 12*(cpi - cpi(-1));                        // Inflation definition (annualised)

// -----------------------------------------------------------------------
// Taylor pricing block  (replaces 2 Calvo equations)
// -----------------------------------------------------------------------

// CPI = equally-weighted average of last n=12 reset prices
// (Dynare creates internal aux vars for lags > 1 automatically)
cpi = (1/12)*(resetprice       + resetprice(-1)  + resetprice(-2)  + resetprice(-3)
            + resetprice(-4)   + resetprice(-5)  + resetprice(-6)  + resetprice(-7)
            + resetprice(-8)   + resetprice(-9)  + resetprice(-10) + resetprice(-11));

// Auxiliary forward-sum variables:
//   z_k  =  sum_{j=0}^{k-1}  beta^j * E_t[nmc_{t+j}]
// Recursive construction:  z_k = nmc + beta * E_t[z_{k-1,t+1}]
// Each equation has exactly ONE lead -- Dynare compliant.
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

// Optimal reset price: present-value average of NMC over 12-period contract
//   p*_t = [(1-beta)/(1-beta^12)] * z12_t
//        = [(1-beta)/(1-beta^12)] * sum_{k=0}^{11} beta^k * E_t[nmc_{t+k}]
resetprice = ((1-bet)/(1-bet^12)) * z12;

// -----------------------------------------------------------------------
// Equations unchanged from Calvo baseline
// -----------------------------------------------------------------------
gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));           // IS equation
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);      // Taylor rule
tot    = rho*tot(-1) + totsh;                                        // Terms-of-trade

end;

shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24,order=1) infl gdp tot nomint;
