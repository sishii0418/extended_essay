%% ============================================================
%% master.m  —  EC424 Essay: Run models & generate Figures 2–3
%%
%% Requires:  inflation.mod
%%            inflation_network_realwage_fix.mod
%% Produces:  figure2_persistence.{png,pdf}
%%            figure3_mechanism.{png,pdf}
%%            irf_data.mat
%% ============================================================
close all; clc;

%% ---- Run baseline model ------------------------------------------------
dynare inflation.mod noclearall nograph
base = oo_.irfs;
close all;

%% ---- Run extended model ------------------------------------------------
dynare inflation_network_realwage_fix.mod noclearall nograph
ext = oo_.irfs;
close all;

%% ---- Save all IRF data for reuse ---------------------------------------
T = 48;
months = 0:(T-1);
save('irf_data.mat', 'base', 'ext', 'T');

%% ========================================================================
%% FIGURE 3 — Extended model: mechanism decomposition (2×3)
%%
%%   Upper row (structural):   tot        rwage      rmc_D
%%   Lower row (outcomes):     infl       gdp        nomint
%% ========================================================================
panels = { ...
%   field        title_str                                 ylabel_str
    'tot',       'Terms of trade ($\hat{s}_t$)',           'Log dev.'; ...
    'rwage',     'Real wage ($\hat{w}_t$)',                'Log dev.'; ...
    'rmc_D',     'Downstream MC ($\hat{x}^D_t$)',         'Log dev.'; ...
    'infl',      'CPI inflation ($\hat{\pi}_t$)',          'Ann. pp'; ...
    'gdp',       'Real GDP ($\hat{y}_t$)',                 'Log dev.'; ...
    'nomint',    'Nominal rate ($\hat{i}_t$)',              'Ann. pp'; ...
};

fig3 = figure('Position', [80 80 1020 580]);

for k = 1:6
    subplot(2, 3, k);

    field = [panels{k,1} '_totsh'];
    irf_k = ext.(field);

    plot(months, irf_k, 'k-', 'LineWidth', 1.5);
    hold on;
    yline(0, 'Color', [0.6 0.6 0.6], 'LineWidth', 0.9);
    hold off;

    title(panels{k,2}, 'Interpreter', 'latex', 'FontSize', 11);
    xlabel('Months', 'FontSize', 8);
    ylabel(panels{k,3}, 'FontSize', 8);
    xlim([0 T-1]);
    grid on;
    set(gca, 'FontSize', 8, 'GridAlpha', 0.25);
end

%%sgtitle('Figure 3: Impulse responses of the extended model', ...
%%      'FontSize', 13, 'FontWeight', 'bold');

print(fig3, '../figure/main_irf', '-dpng', '-r300');
%%print(fig3, '../figure/main_irf', '-dpdf');

%% ========================================================================
%% FIGURE 2 — Normalised persistence comparison
%%
%%   Three lines, each normalised by its period-1 value:
%%     (1) Terms of trade        — black dashed  (shock decay)
%%     (2) Baseline CPI infl     — grey thin      (fast decay)
%%     (3) Extended CPI infl     — blue thick      (persistent)
%% ========================================================================
tot_norm       = ext.tot_totsh    / ext.tot_totsh(1);
base_infl_norm = base.infl_totsh  / base.infl_totsh(1);
ext_infl_norm  = ext.infl_totsh   / ext.infl_totsh(1);

fig2 = figure('Position', [80 80 750 460]);
hold on;

h1 = plot(months, tot_norm,       '-.', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5);
h2 = plot(months, base_infl_norm, '-', 'Color', [0.0   0.447 0.698], 'LineWidth', 1.8);  % #0072B2 blue = baseline
h3 = plot(months, ext_infl_norm,  '-', 'Color', [0.835 0.369 0.0],   'LineWidth', 2.2);  % #D55E00 orange = extended
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.9);

hold off;

xlabel('Months after shock', 'FontSize', 11);
ylabel('Fraction of period-1 response', 'FontSize', 11);
%%title('Figure 2: Inflation persistence vs energy-price shock decay', ...
%%      'FontSize', 13, 'FontWeight', 'bold');
legend([h1 h2 h3], ...
       'Terms of trade ($\hat{s}_t$)', ...
       'Baseline model CPI inflation', ...
       'Extended model CPI inflation', ...
       'Interpreter', 'latex', 'Location', 'northeast', 'FontSize', 10);
xlim([0 T-1]);
grid on;
set(gca, 'FontSize', 10, 'GridAlpha', 0.25);

print(fig2, '../figure/persistence_comparison', '-dpng', '-r300');
%%print(fig2, 'figure2_persistence', '-dpdf');

%% ---- Done --------------------------------------------------------------
fprintf('\n===== Saved =====\n');
fprintf('  figure2_persistence.png  (.pdf)\n');
fprintf('  figure3_mechanism.png    (.pdf)\n');
fprintf('  irf_data.mat\n');
fprintf('=================\n');