// Dynare script for inflation dynamics model
// EXTENSION: Search & Matching + CES production (epsilon=0.37) + Real Wage Rigidity
//
// CES production function (Gagliardone & Gertler 2025):
//   y_t = [alpha^(1/eps)*n_t^((eps-1)/eps) + (1-alpha)^(1/eps)*o_t^((eps-1)/eps)]^(eps/(eps-1))
//   eps = 0.37: oil and labour are COMPLEMENTS (eps < 1)
//
// Correct log-linearization of CES marginal cost:
//   From dual cost function:
//   rmc = (1-alph)*rwage + alph*tot
//   This is IDENTICAL in form to Leontief; eps does NOT appear here.
//
// CES mechanism enters through:
//   (1) Oil demand: o - n = eps*(rwage - tot)   [from FOC ratio]
//       -> eps < 1: when tot rises, (o-n) falls less than under Cobb-Douglas
//       -> oil-labour complementarity
//
//   (2) Marginal product of labour (MPL):
//       mpl = -(1/eps)*(o - n) = -(1/eps)*eps*(rwage - tot) = -(rwage - tot)
//       -> when tot rises (energy expensive), firms reduce o -> MPL falls
//       -> mpl = tot - rwage  [log deviation from SS]
//
//   (3) Nash wage includes MPL:
//       wnash = sigm*(rmc + c*theta/q) + sigm*mpl + (1-sigm)*b
//       Log-lin: wnash = sigm*rmc + sigm*tightness + sigm*mpl
//       -> MPL depression dampens Nash wage
//       -> real wage rigidity means actual wage stays high relative to MPL
//       -> unit labour cost stays elevated -> inflation persists
//
// S&M + CES mechanism for inflation persistence:
//   Energy shock -> tot rises -> mpl = tot - rwage rises (mpl depr'n)
//   But: S&M means n recovers slowly -> o stays low relative to SS
//        -> MPL stays depressed for longer
//   Real wage rigidity: rwage doesn't fall as fast as Nash wage would
//   -> rmc = (1-alph)*rwage + alph*tot stays high -> inflation persists
//
// Variables (18): adds o and mpl to 16-variable S&M model
// Equations (18): rmc simplified + 2 new equations (oil demand, MPL)

// -----------------------------------------------------------------------
// Variables (18)
// -----------------------------------------------------------------------
var infl cpi resetprice gdp cons n u v tightness qrate
    rwage wnash rmc nmc nomint tot o mpl;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, thetap, gamma, sigm, rhon, nbar, ubar, cvratio,
           epsilon_ces, intsub, phi, chipi, chiy, rho;

alph        = 0.15;   // Oil share of production cost (= 1 - labour share)
rbar        = 2;
intsub      = 0.5;
thetap      = 11/12;  // Calvo price stickiness (thetap, not tightness)
phi         = 0.9;
chipi       = 3;
chiy        = 0.5;
rho         = 0.8;

epsilon_ces = 0.37;   // CES elasticity of substitution (G&G 2025 estimate)
                      // eps < 1: oil-labour complements
                      // eps = 1: Cobb-Douglas
                      // eps -> 0: Leontief

gamma   = 0.705;
sigm    = 0.5;
rhon    = 0.96;
nbar    = 0.95;
ubar    = 0.05;
cvratio = 0.01;

bet = (1/(1+(rbar/100)))^(1/12);

// -----------------------------------------------------------------------
// Model (18 equations)
// -----------------------------------------------------------------------
model(linear);

// =======================================================================
// BLOCK 1: Price setting (6 equations)
// =======================================================================

// CES real marginal cost (from dual cost function log-linearization)
// rmc = (1-alph)*rwage + alph*tot
// NOTE: this is IDENTICAL to Leontief in log-linear form.
// CES mechanism enters through MPL in Nash wage (see below).
rmc = (1-alph)*rwage + alph*tot;

// Nominal marginal cost
nmc = rmc + cpi;

// Annualised inflation
infl = 12*(cpi - cpi(-1));

// Calvo price index
cpi = thetap*cpi(-1) + (1-thetap)*resetprice;

// Calvo reset price
resetprice = bet*thetap*resetprice(+1) + (1-bet*thetap)*nmc;

// Taylor rule
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// =======================================================================
// BLOCK 2: Output, demand, and oil (5 equations)
// =======================================================================

// IS curve (consumption Euler equation, C ≠ Y)
cons = cons(+1) - intsub*((nomint/12) - (infl(+1)/12));

// Resource constraint: Y = C + c*v
gdp = cons + cvratio*v;

// Terms-of-trade shock
tot = rho*tot(-1) + totsh;

// Oil demand from CES cost minimisation (FOC ratio: w/s = f(o/n))
// From: w_t/s_t = ((1-alph)/alph)^(1/eps) * (o_t/n_t)^(1/eps)
// Log-lin: rwage - tot = (1/eps)*(o - n)
// -> o - n = eps*(rwage - tot)
// -> o = n + eps*(rwage - tot)
o = n + epsilon_ces*(rwage - tot);

// Marginal product of labour (log deviation from SS)
// From labour FOC: w_t = p^w_t * (1-alph)^(1/eps) * (y_t/n_t)^(1/eps)
// Log-lin: rwage = rmc + (1/eps)*(gdp - n)
// -> mpl = gdp - n [log deviation of (y/n), proportional to MPL]
// Using gdp = (1-alph)*n + alph*o (CES log-lin):
// gdp - n = alph*(o - n) = alph*eps*(rwage - tot)
// -> mpl = alph*epsilon_ces*(rwage - tot)
// When tot rises (energy expensive): mpl falls if rwage does not adjust
// Real wage rigidity: rwage stays high -> mpl stays depressed -> inflation persists
mpl = alph*epsilon_ces*(rwage - tot);

// =======================================================================
// BLOCK 3: Search & Matching labour market (7 equations)
// =======================================================================

// Unemployment
u = -(rhon*nbar/ubar)*n(-1);

// Vacancy filling rate
qrate = -sigm*tightness;

// Vacancies
v = tightness + u;

// Employment law of motion
n = rhon*n(-1) + (1-rhon)*(qrate + v);

// Job Creation condition
// With CES+MPL: surplus = rmc + mpl - rwage (MPL affects firm value of worker)
// From: c/q_t = bet*rhon*E[c/q_{t+1}] + (p^w_t * mpl_t - rwage_t)
//             = bet*rhon*E[c/q_{t+1}] + (rmc + mpl - rwage)
// Log-lin (c/q hat = sigm*tightness):
sigm*tightness = (1-bet*rhon)*(rmc + mpl - rwage) + bet*rhon*sigm*tightness(+1);

// Nash wage (includes MPL: workers share in productivity gains)
// wnash = sigm*(rmc + mpl + c*theta/q) + (1-sigm)*b
// Log-lin (b=0 normalisation, Hosios sigm=varsigma):
wnash = sigm*(rmc + mpl) + sigm*tightness;

// Real wage rigidity (G&G 2025)
rwage = (1-gamma)*wnash;

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint u tightness rwage mpl o;
