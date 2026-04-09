// Dynare script for inflation dynamics model
// EXTENSION: Sticky Information (Klenow-Willis approx.) + Real Wage Rigidity
//
// Motivation:
//   Two independent backward-looking channels for inflation persistence:
//
//   (1) Sticky Information (Mankiw & Reis 2002, KW 2007 approx., lambda=0.91):
//       Russia's invasion of Ukraine (Feb 2022) was unforeseeable. Firms
//       could not predict how long high energy prices would last. Only a
//       fraction (1-lambda) update their information each period; the rest
//       continue pricing on outdated information -> backward-looking inertia.
//       Channel: non-updating firms reference past (high) nmc expectations.
//
//   (2) Real Wage Rigidity (psi_w=0.705, Gagliardone & Gertler 2025):
//       Brexit-induced labour shortages created unprecedented UK labour market
//       tightness (BoE MPC 2022). Labour hoarding and search frictions mean
//       real wages adjust only gradually toward their flexible equilibrium.
//       Channel: rwage(-1) enters rmc, creating cost-side persistence.
//
//   These two channels are INDEPENDENTLY motivated (no circularity):
//   - SI: unforeseeable geopolitical shock (Ukraine) -> lambda > 0
//   - RWR: structural labour supply reduction (Brexit) -> psi_w > 0
//
// Complementarity between the two extensions:
//   Real wage rigidity keeps nmc elevated (cost channel).
//   Sticky information means non-updating firms reference this elevated nmc,
//   perpetuating high prices even after the energy shock recedes.
//   Without RWR: SI firms reference nmc that quickly falls (rho=0.8).
//   Without SI:  Calvo is purely forward-looking; RWR effect is mild.
//   Together: RWR sustains nmc; SI propagates it through price setting.
//
// Changes from baseline (inflation.mod):
//   REMOVED:
//     resetprice variable
//     cpi = theta*cpi(-1) + (1-theta)*resetprice       [Calvo CPI]
//     resetprice = bet*theta*resetprice(+1) + ...       [Calvo reset price]
//     rwage = (1/intsub)*gdp + (1/frisch)*employ        [flexible wage]
//
//   ADDED:
//     h1, rwage_flex variables (+2)
//     h1         = nmc(+1)                              [1-period forecast]
//     cpi        = KW-SI equation                       [SI CPI]
//     rwage_flex = (1/intsub)*gdp + (1/frisch)*employ   [flex wage benchmark]
//     rwage      = psi_w*rwage(-1)+(1-psi_w)*rwage_flex [partial adjustment]
//
//   Variable count: 10 - 1(resetprice) + 2(h1, rwage_flex) = 11
//   Equation count: 10 - 3(Calvo CPI, reset, flex wage) + 4(above) = 11

// -----------------------------------------------------------------------
// Variables (11)
// -----------------------------------------------------------------------
var infl cpi gdp employ nomint rwage rwage_flex rmc nmc tot h1;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, lambda_si, psi_w, intsub, frisch, phi, chipi, chiy, rho;

alph      = 0.15;   // Energy share of total cost (Leontief)
rbar      = 2;      // Steady-state real interest rate (annual %)
intsub    = 0.5;    // Elasticity of intertemporal substitution
frisch    = 3;      // Frisch elasticity of labour supply
lambda_si = 0.91;   // SI: fraction NOT updating information each period
                    // Source: Mankiw-Reis (2002) quarterly est. 0.75
                    //         -> monthly: 0.75^(1/3) ≈ 0.91
                    //         avg update interval: 1/(1-0.91) ≈ 11 months
psi_w     = 0.705;  // RWR: degree of real wage rigidity
                    // Source: Gagliardone & Gertler (2025) estimated value
                    // psi_w=0: flexible wages (baseline)
                    // psi_w=0.705: only 29.5% adjustment per period
phi       = 0.9;    // Interest-rate smoothing
chipi     = 3;      // Taylor rule: inflation response
chiy      = 0.5;    // Taylor rule: GDP response
rho       = 0.7;    // Persistence of terms-of-trade shock (baseline value)

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model (11 equations)
// -----------------------------------------------------------------------
model(linear);

// =======================================================================
// BLOCK 1: Standard equations (6, same structure as baseline)
// =======================================================================

gdp   = employ - alph*tot;          // Aggregate production function
rmc   = rwage + alph*tot;           // Real marginal cost (rwage from RWR below)
nmc   = rmc + cpi;                  // Nominal marginal cost
infl  = 12*(cpi - cpi(-1));         // Annualised CPI inflation

// IS equation (unchanged)
gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));

// Taylor rule (unchanged)
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// Terms of trade shock (unchanged, rho=0.8)
tot = rho*tot(-1) + totsh;

// =======================================================================
// BLOCK 2: Sticky Information - Klenow-Willis approximation (2 equations)
// Replaces 2 Calvo equations (cpi index + reset price)
// =======================================================================

// 1-period-ahead forecast of nmc
// h1_t = E_t[nmc_{t+1}]
// -> h1(-1) = E_{t-1}[nmc_t]  (used in KW equation)
h1 = nmc(+1);

// Klenow-Willis SI CPI:
//   cpi_t = (1-lambda)*nmc_t + lambda*(cpi_{t-1} + E_{t-1}[nmc_t - nmc_{t-1}])
//         = (1-lambda)*nmc_t + lambda*(cpi_{t-1} + h1(-1) - nmc(-1))
//
// Intuition:
//   Fraction (1-lambda)=0.09: update info -> set price = current nmc
//   Fraction lambda=0.91: no update -> adjust last period's price
//     by their EXPECTED change: E_{t-1}[Δnmc_t] = h1(-1) - nmc(-1)
//
// With rho=0.8 and RWR:
//   Without RWR: nmc falls quickly (rho=0.8) -> non-updaters
//                expect nmc to fall -> price down -> no persistence
//   WITH RWR:    rwage(-1) keeps nmc elevated despite tot falling
//                -> non-updaters reference high past nmc
//                -> SI backward-looking channel is activated
cpi = (1-lambda_si)*nmc + lambda_si*(cpi(-1) + h1(-1) - nmc(-1));

// =======================================================================
// BLOCK 3: Real Wage Rigidity (2 equations)
// Replaces 1 flexible wage equation
// =======================================================================

// Flexible wage benchmark (what wage would be under full flexibility)
rwage_flex = (1/intsub)*gdp + (1/frisch)*employ;

// Partial adjustment toward flexible wage:
//   rwage_t = psi_w*rwage_{t-1} + (1-psi_w)*rwage_flex_t
//
// psi_w=0: rwage = rwage_flex (baseline, no rigidity)
// psi_w=0.705: rwage adjusts only 29.5% toward flex wage per period
//
// Backward-looking channel:
//   rwage(-1) enters rmc = rwage + alph*tot
//   -> rmc inherits the inertia of past wages
//   -> even after tot falls, rmc stays elevated due to past high wages
//   -> nmc = rmc + cpi stays elevated
//   -> activates SI: non-updating firms reference this elevated nmc
rwage = psi_w*rwage(-1) + (1-psi_w)*rwage_flex;

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=50, order=1) infl gdp tot nomint rwage;
