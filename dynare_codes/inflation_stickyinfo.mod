// Dynare script for inflation dynamics model
// EXTENSION: Sticky Information pricing (Mankiw & Reis, 2002, QJE)
//
// Motivation:
//   The 2021-22 UK energy price surge was driven partly by Russia's
//   invasion of Ukraine - an unforeseeable event. Firms faced genuine
//   uncertainty about whether high energy prices were temporary or
//   permanent. Sticky information captures this: only a fraction (1-lambda)
//   of firms update their information set each period; the rest continue
//   setting prices based on outdated information. This generates
//   backward-looking inflation dynamics without assuming indexation.
//
// Key difference from Calvo pricing:
//   Calvo:            PRICES are rigid (some firms cannot change price)
//   Sticky Information: INFORMATION is rigid (all firms can change price,
//                       but only some have current-period information)
//
// Implication for inflation persistence:
//   Calvo NKPC:   pi_t = beta*E_t[pi_{t+1}] + xi*mc_t  (forward-looking)
//   SI NKPC:      pi_t proportional to Sigma lambda^j * E_{t-1-j}[pi_t + ...]
//                 -> current inflation reflects PAST expectations (backward-looking)
//
// Implementation: truncated sum (J=12 months)
//   p_t = [(1-lambda)/(1-lambda^13)] * Sigma_{j=0}^{12} lambda^j * E_{t-j}[nmc_t]
//
//   where E_{t-j}[nmc_t] = h_j evaluated at time t-j = hj(-j)
//   and hk_t = E_t[nmc_{t+k}], defined recursively as hk = h{k-1}(+1)
//
//   Renormalisation (1-lambda)/(1-lambda^13) ensures weights sum to 1
//   with finite truncation at J=12 (approximation error ~3% for lambda=0.91)
//
// Parameter calibration:
//   lambda = 0.91 (monthly): consistent with Mankiw-Reis (2002) quarterly
//   estimate lambda_Q = 0.75, converted to monthly as 0.75^(1/3) ≈ 0.91
//   -> average information update interval: 1/(1-0.91) ≈ 11 months
//   -> comparable to Calvo theta=11/12 -> avg price duration 12 months
//
// Changes from baseline (inflation.mod):
//   REMOVED:
//     resetprice variable
//     cpi = theta*cpi(-1) + (1-theta)*resetprice         [Calvo CPI]
//     resetprice = bet*theta*resetprice(+1) + ...        [Calvo reset price]
//   ADDED:
//     Variables h1,...,h12 (forecast auxiliary variables)
//     cpi = SI equation                                   [SI CPI]
//     h1 = nmc(+1)                                       [1-period forecast]
//     h2 = h1(+1), ..., h12 = h11(+1)                   [k-period forecasts]
//
//   Variable count: 10 - 1(resetprice) + 12(h1..h12) = 21
//   Equation count: 10 - 2(Calvo) + 1(SI CPI) + 12(h eqs) = 21

// -----------------------------------------------------------------------
// Variables (21)
// -----------------------------------------------------------------------
var infl cpi gdp employ nomint rwage rmc nmc tot
    h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12;

varexo totsh;

// -----------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------
parameters alph, bet, lambda_si, intsub, frisch, phi, chipi, chiy, rho;

alph      = 0.15;  // Energy share of total cost (Leontief)
rbar      = 2;     // Steady-state real interest rate (annual %)
intsub    = 0.5;   // Elasticity of intertemporal substitution
frisch    = 3;     // Frisch elasticity of labour supply
lambda_si = 0.5;  // Sticky information parameter (monthly)
                   // MR(2002): lambda_Q = 0.75 -> lambda_M = 0.75^(1/3) ≈ 0.91
                   // Average info update interval: 1/(1-0.91) ≈ 11 months
phi       = 0.9;   // Interest-rate smoothing
chipi     = 3;     // Taylor rule: inflation response
chiy      = 0.5;   // Taylor rule: GDP response
rho       = 0.8;   // Persistence of terms-of-trade shock

bet = (1/(1+(rbar/100)))^(1/12);  // Monthly discount factor

// -----------------------------------------------------------------------
// Model (21 equations)
// -----------------------------------------------------------------------
model(linear);

// =======================================================================
// BLOCK 1: Standard equations (unchanged from baseline, no resetprice)
// =======================================================================
gdp   = employ - alph*tot;                          // Production function
rmc   = rwage + alph*tot;                           // Real marginal cost
nmc   = rmc + cpi;                                  // Nominal marginal cost
rwage = (1/intsub)*gdp + (1/frisch)*employ;         // Labour supply (flexible)
infl  = 12*(cpi - cpi(-1));                         // Annualised CPI inflation

// IS equation (unchanged)
gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));

// Taylor rule (unchanged)
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// Terms of trade shock (unchanged)
tot = rho*tot(-1) + totsh;

// =======================================================================
// BLOCK 2: Sticky Information CPI (replaces 2 Calvo equations)
// =======================================================================

// Sticky Information CPI equation:
//   p_t = [(1-lambda)/(1-lambda^13)] * Sigma_{j=0}^{12} lambda^j * E_{t-j}[nmc_t]
//
//   E_{t-j}[nmc_t] = hj_{t-j} = hj(-j) in Dynare notation
//     j=0: E_t[nmc_t]      = nmc_t     (current info)
//     j=1: E_{t-1}[nmc_t]  = h1(-1)    (1-period-old info)
//     j=2: E_{t-2}[nmc_t]  = h2(-2)    (2-period-old info)
//     ...
//     j=12: E_{t-12}[nmc_t] = h12(-12) (12-period-old info)
//
//   Renormalisation: (1-lambda)/(1-lambda^13) ensures weights sum to 1
//   For lambda=0.91, J=12: sum of weights ≈ 0.97 (3% truncation error)
cpi = ((1-lambda_si)/(1-lambda_si^13))*(
        nmc
      + lambda_si    * h1(-1)
      + lambda_si^2  * h2(-2)
      + lambda_si^3  * h3(-3)
      + lambda_si^4  * h4(-4)
      + lambda_si^5  * h5(-5)
      + lambda_si^6  * h6(-6)
      + lambda_si^7  * h7(-7)
      + lambda_si^8  * h8(-8)
      + lambda_si^9  * h9(-9)
      + lambda_si^10 * h10(-10)
      + lambda_si^11 * h11(-11)
      + lambda_si^12 * h12(-12));

// =======================================================================
// BLOCK 3: Forecast auxiliary variables
// hk_t = E_t[nmc_{t+k}] (k-period-ahead forecast of nmc from current period)
//
// Derivation: h1_t = E_t[nmc_{t+1}]      -> h1 = nmc(+1)
//             h2_t = E_t[nmc_{t+2}]
//                  = E_t[E_{t+1}[nmc_{t+2}]]  (law of iterated expectations)
//                  = E_t[h1_{t+1}]             -> h2 = h1(+1)
//             hk_t = E_t[h{k-1}_{t+1}]        -> hk = h{k-1}(+1)
//
// In Dynare's linear model, x(+1) denotes E_t[x_{t+1}], so this is valid.
// These equations are forward-looking; Dynare solves for them as
// functions of the current state variables via RE solution.
// =======================================================================
h1  = nmc(+1);
h2  = h1(+1);
h3  = h2(+1);
h4  = h3(+1);
h5  = h4(+1);
h6  = h5(+1);
h7  = h6(+1);
h8  = h7(+1);
h9  = h8(+1);
h10 = h9(+1);
h11 = h10(+1);
h12 = h11(+1);

end;

// -----------------------------------------------------------------------
// Shocks
// -----------------------------------------------------------------------
shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24, order=1) infl gdp tot nomint;
