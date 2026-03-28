// Dynare script for inflation dynamics model
// EXTENSION: Calvo pricing with price indexation
// Compares gamma = 0 (baseline), 0.5, 0.75
// rho = 0.8 (baseline value)

var infl cpi resetprice gdp employ nomint rwage rmc nmc tot;
varexo totsh;

parameters alph, bet, theta, gamma, intsub, frisch, phi, chipi, chiy, rho;

alph   = 0.15;
rbar   = 2;
intsub = 0.5;
frisch = 3;
theta  = 11/12;
gamma  = 0;      // will be overwritten in loop
phi    = 0.9;
chipi  = 3;
chiy   = 0.5;
rho    = 0.8;

bet = (1/(1+(rbar/100)))^(1/12);

model(linear);
gdp   = employ - alph*tot;
rmc   = rwage + alph*tot;
nmc   = rmc + cpi;
rwage = (1/intsub)*gdp + (1/frisch)*employ;
infl  = 12*(cpi - cpi(-1));

cpi = theta*(1+gamma)*cpi(-1) - theta*gamma*cpi(-2) + (1-theta)*resetprice;

resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc
             - bet*theta*gamma*(cpi - cpi(-1));

gdp    = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);
tot    = rho*tot(-1) + totsh;
end;

shocks;
var totsh; stderr 100;
end;

// -----------------------------------------------------------------------
// Loop over gamma values, store IRFs
// -----------------------------------------------------------------------
gamma_values = [0, 0.5, 0.75];
gamma_labels = {'$\gamma=0$ (baseline)', '$\gamma=0.5$', '$\gamma=0.75$'};
colors       = {'k-', 'b--', 'r:'};
IRF_infl   = zeros(24, 3);
IRF_gdp    = zeros(24, 3);
IRF_nomint = zeros(24, 3);
IRF_tot    = zeros(24, 3);

for i = 1:3
    set_param_value('gamma', gamma_values(i));
    stoch_simul(irf=24, order=1, noprint, nograph) infl gdp tot nomint;
    IRF_infl(:,i)   = oo_.irfs.infl_totsh';
    IRF_gdp(:,i)    = oo_.irfs.gdp_totsh';
    IRF_nomint(:,i) = oo_.irfs.nomint_totsh';
    IRF_tot(:,i)    = oo_.irfs.tot_totsh';
end

// -----------------------------------------------------------------------
// Plot comparison
// -----------------------------------------------------------------------
figure('Name', 'IRF Comparison: Indexation');

subplot(2,2,1);
hold on;
for i = 1:3
    plot(1:24, IRF_infl(:,i), colors{i}, 'LineWidth', 1.5);
end
yline(0, 'r-');
title('infl');
legend(gamma_labels, 'Location', 'NorthEast', 'Interpreter', 'latex');
xlabel('Months'); ylabel('Annual %');

subplot(2,2,2);
hold on;
for i = 1:3
    plot(1:24, IRF_gdp(:,i), colors{i}, 'LineWidth', 1.5);
end
yline(0, 'r-');
title('gdp');
legend(gamma_labels, 'Location', 'SouthEast', 'Interpreter', 'latex');
xlabel('Months');

subplot(2,2,3);
plot(1:24, IRF_tot(:,1), 'k-', 'LineWidth', 1.5);  // tot is same across gamma
yline(0, 'r-');
title('tot');
xlabel('Months');

subplot(2,2,4);
hold on;
for i = 1:3
    plot(1:24, IRF_nomint(:,i), colors{i}, 'LineWidth', 1.5);
end
yline(0, 'r-');
title('nomint');
legend(gamma_labels, 'Location', 'NorthEast', 'Interpreter', 'latex');
xlabel('Months');
