// ============================================================
// Production Network Model with Myopia + Real Wage Rigidity
// EC424 Structured Research Assignment
//
// Structure:
//   Upstream (U): energy + labour -> intermediate goods (Calvo, theta_U)
//   Downstream (D): upstream goods + labour -> final consumption (Calvo, theta_D)
//   Households: consume downstream goods only -> CPI = cpi (= cpi_D)
//
// Extensions vs. baseline:
//   1. Two-sector IO linkage: downstream MC depends on upstream price (cpi_U)
//   2. Myopia (mf): downstream firms discount expected future MC changes
//   3. Real wage rigidity (psi_w): real wage adjusts gradually
//      -> second-round effects: inflation persists after energy shock reverts
//
// References: Minton & Wheaton (2023), Carvalho & Tahbaz-Salehi (2019),
//             Gagliardone & Gertler (2025)
// ============================================================

// infl: aggregate (downstream) CPI inflation, annualised %
// cpi: downstream price level (= aggregate CPI)
// resetprice_D: downstream Calvo reset price
// gdp: real GDP (downstream output)
// employ: total employment
// nomint: nominal interest rate, annualised %
// rwage: real wage (relative to downstream CPI)
// rmc_D: downstream real marginal cost
// nmc_D: downstream nominal marginal cost
// tot: terms of trade (log deviation from ss)
// cpi_U: upstream price level
// resetprice_U: upstream Calvo reset price
// infl_U: upstream inflation, annualised %
var infl cpi resetprice_D gdp employ nomint rwage rmc_D nmc_D tot cpi_U resetprice_U infl_U;

varexo totsh;  // Energy price shock

parameters alph      // Energy share in upstream production cost
           bet       // Monthly discount factor
           theta_D   // Calvo prob. no adjustment: downstream
           theta_U   // Calvo prob. no adjustment: upstream
           alph_D    // Downstream upstream-input share (alpha^D in model)
           epsil     // Elasticity of substitution across varieties (CES)
           Phi_DU    // SS cost share of upstream goods in downstream MC
           mf        // Myopia parameter (0=complete myopia, 1=RE)
           psi_w     // Real wage rigidity (0=flexible, 1=fixed)
           intsub    // Elasticity of intertemporal substitution
           frisch    // Frisch elasticity of labour supply
           phi       // Interest-rate smoothing
           chipi     // Taylor rule: inflation response
           chiy      // Taylor rule: GDP response
           rho;      // Persistence of ToT shock

// --- Calibration ---
alph    = 0.375;     // Energy share (upstream), from baseline
rbar    = 2;        // Steady-state real rate (annual %)
intsub  = 0.5;      // EIS, from baseline
frisch  = 3;        // Frisch elasticity, from baseline
theta_D = 11/12;    // Downstream Calvo (= baseline theta; avg. price duration 12 months)
theta_U = 0.75;      // Upstream Calvo (avg. price duration 4 months; sensitivity: 0.3, 0.7)
alph_D  = 0.4;     // Downstream upstream-input share alpha^D (sensitivity: 0.05, 0.15)
mf      = 0.5;      // Myopia (sensitivity: 0, 1)
psi_w   = 0.9^(1/3);    // Real wage rigidity
phi     = 0.9;      // Taylor smoothing, from baseline
chipi   = 3;        // Taylor inflation response, from baseline
chiy    = 0.5;      // Taylor GDP response, from baseline
rho     = 0.8;      // ToT persistence, from baseline

bet = (1/(1+(rbar/100)))^(1/12);  // Implied monthly discount factor
epsil = 11;                       // CES elasticity of substitution across varieties
                                  // => markup mu^U = epsil/(epsil-1) = 11/10 = 1.1

// Phi_DU: SS cost share of upstream goods in downstream MC
// From log-linearisation of x^D_t = (1-alph_D + alph_D * P^U/W) * w
// where P^U/W = mu^U = epsil/(epsil-1) in steady state
// Phi_DU = alph_D * mu^U / (1 - alph_D + alph_D * mu^U)
Phi_DU = alph_D*(epsil/(epsil-1)) / (1 - alph_D + alph_D*(epsil/(epsil-1)));

model(linear);

// --------------------------------------------------------
// (1) Aggregate production function (two-sector derivation)
//     hat{y}_t = hat{l}_t - alpha*alpha^D*hat{s}_t
//     alph*alph_D: composite energy share
//     (= upstream energy share * downstream upstream-input share)
// --------------------------------------------------------
gdp = employ - alph*alph_D*tot;

// --------------------------------------------------------
// (2) Downstream marginal cost
//     From log-lin of x^D = (1-alph_D + alph_D*P^U/W)*w:
//     rmc_D = Phi_DU*(cpi_U - cpi) + (1-Phi_DU)*rwage
//     where Phi_DU = alph_D*mu^U / (1-alph_D+alph_D*mu^U)
//     nmc_D = rmc_D + cpi
// --------------------------------------------------------
rmc_D = Phi_DU*(cpi_U - cpi) + (1-Phi_DU)*rwage;
nmc_D = rmc_D + cpi;

// --------------------------------------------------------
// (3) Real wage rigidity
//     psi_w=0: flexible wage (= baseline labour supply condition)
//     psi_w=1: completely rigid real wage
//     Mechanism: even after tot reverts, rwage remains depressed,
//     workers push wages up gradually → rmc_D stays elevated
//     → second-round inflation persistence
// --------------------------------------------------------
rwage = psi_w*rwage(-1) + (1-psi_w)*((1/intsub)*gdp + (1/frisch)*employ);

// --------------------------------------------------------
// (4) Inflation definitions (annualised)
// --------------------------------------------------------
infl   = 12*(cpi   - cpi(-1));    // Downstream = aggregate CPI inflation
infl_U = 12*(cpi_U - cpi_U(-1)); // Upstream inflation

// --------------------------------------------------------
// (5) Downstream Calvo price block (with myopia mf)
//     Standard Calvo if mf=1; purely static if mf=0
// --------------------------------------------------------
cpi = theta_D*cpi(-1) + (1-theta_D)*resetprice_D;
resetprice_D = bet*mf*theta_D*resetprice_D(+1) + (1-bet*mf*theta_D)*nmc_D;

// --------------------------------------------------------
// (6) Upstream Calvo price block (rational expectations)
//     Upstream firms observe tot directly; no myopia needed
//     nmc_U = (rwage + cpi) + alph*tot  [= nominal wage + energy cost]
// --------------------------------------------------------
cpi_U = theta_U*cpi_U(-1) + (1-theta_U)*resetprice_U;
resetprice_U = bet*theta_U*resetprice_U(+1) + (1-bet*theta_U)*(rwage + cpi + alph*tot);

// --------------------------------------------------------
// (7) IS equation
// --------------------------------------------------------
gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));

// --------------------------------------------------------
// (8) Taylor rule
// --------------------------------------------------------
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// --------------------------------------------------------
// (9) Exogenous ToT process
// --------------------------------------------------------
tot = rho*tot(-1) + totsh;

end;

shocks;
var totsh; stderr 100;
end;

// IRF horizon 48 months (= 4 years) to capture persistent dynamics
stoch_simul(irf=48, order=1) tot rwage rmc_D infl gdp nomint;
saveas(gcf, "../figure/main_irf.png");
save("main_results.mat", "oo_", "M_", "options_");