// Dynare script for inflation dynamics model

// Endogenous variables
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot;

// Exogenous variables
varexo totsh;

// Parameters
parameters alph, bet, theta, intsub, frisch, phi, chipi, chiy, rho;

alph = 0.15; // Energy share of total cost of production
rbar = 2; // Steady-state real interest rate of 2% annual
intsub = 0.5; // Elasticity of intertemporal substitution
frisch = 3; // Frisch elasticity of labour supply
theta = 11/12; // Calvo probability of no change to a nominal price
phi = 0.9; // Interest-rate smoothing parameter
chipi = 3; // Taylor-rule response to inflation
chiy = 0.5; // Taylor-rule response to GDP
rho = 0.8; // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12); // Implied discount factor

model(linear);

gdp = employ - alph*tot; // Aggregate production function
rmc = rwage + alph*tot; // Real marginal cost
nmc = rmc + cpi; // Nominal marginal cost definition
rwage = (1/intsub)*gdp + (1/frisch)*employ; // Labour supply curve
infl = 12*(cpi - cpi(-1)); // Inflation definition
cpi = theta*cpi(-1) + (1-theta)*resetprice; // Calvo price stickiness
resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc; // Calvo price setting
gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12)); // IS equation
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp); // Taylor rule
tot = rho*tot(-1) + totsh; // Exogenous process for terms of trade

end;

shocks;

var totsh; stderr 100;

end;

stoch_simul(irf=24,order=1) infl gdp tot nomint;
