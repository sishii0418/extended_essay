%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

clearvars -global
clear_persistent_variables(fileparts(which('dynare')), false)
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info
options_ = [];
M_.fname = 'inflation_si_kw';
M_.dynare_version = '7.0';
oo_.dynare_version = '7.0';
options_.dynare_version = '7.0';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(1,1);
M_.exo_names_tex = cell(1,1);
M_.exo_names_long = cell(1,1);
M_.exo_names(1) = {'totsh'};
M_.exo_names_tex(1) = {'totsh'};
M_.exo_names_long(1) = {'totsh'};
M_.endo_names = cell(10,1);
M_.endo_names_tex = cell(10,1);
M_.endo_names_long = cell(10,1);
M_.endo_names(1) = {'infl'};
M_.endo_names_tex(1) = {'infl'};
M_.endo_names_long(1) = {'infl'};
M_.endo_names(2) = {'cpi'};
M_.endo_names_tex(2) = {'cpi'};
M_.endo_names_long(2) = {'cpi'};
M_.endo_names(3) = {'gdp'};
M_.endo_names_tex(3) = {'gdp'};
M_.endo_names_long(3) = {'gdp'};
M_.endo_names(4) = {'employ'};
M_.endo_names_tex(4) = {'employ'};
M_.endo_names_long(4) = {'employ'};
M_.endo_names(5) = {'nomint'};
M_.endo_names_tex(5) = {'nomint'};
M_.endo_names_long(5) = {'nomint'};
M_.endo_names(6) = {'rwage'};
M_.endo_names_tex(6) = {'rwage'};
M_.endo_names_long(6) = {'rwage'};
M_.endo_names(7) = {'rmc'};
M_.endo_names_tex(7) = {'rmc'};
M_.endo_names_long(7) = {'rmc'};
M_.endo_names(8) = {'nmc'};
M_.endo_names_tex(8) = {'nmc'};
M_.endo_names_long(8) = {'nmc'};
M_.endo_names(9) = {'tot'};
M_.endo_names_tex(9) = {'tot'};
M_.endo_names_long(9) = {'tot'};
M_.endo_names(10) = {'h1'};
M_.endo_names_tex(10) = {'h1'};
M_.endo_names_long(10) = {'h1'};
M_.endo_partitions = struct();
M_.param_names = cell(9,1);
M_.param_names_tex = cell(9,1);
M_.param_names_long = cell(9,1);
M_.param_names(1) = {'alph'};
M_.param_names_tex(1) = {'alph'};
M_.param_names_long(1) = {'alph'};
M_.param_names(2) = {'bet'};
M_.param_names_tex(2) = {'bet'};
M_.param_names_long(2) = {'bet'};
M_.param_names(3) = {'lambda_si'};
M_.param_names_tex(3) = {'lambda\_si'};
M_.param_names_long(3) = {'lambda_si'};
M_.param_names(4) = {'intsub'};
M_.param_names_tex(4) = {'intsub'};
M_.param_names_long(4) = {'intsub'};
M_.param_names(5) = {'frisch'};
M_.param_names_tex(5) = {'frisch'};
M_.param_names_long(5) = {'frisch'};
M_.param_names(6) = {'phi'};
M_.param_names_tex(6) = {'phi'};
M_.param_names_long(6) = {'phi'};
M_.param_names(7) = {'chipi'};
M_.param_names_tex(7) = {'chipi'};
M_.param_names_long(7) = {'chipi'};
M_.param_names(8) = {'chiy'};
M_.param_names_tex(8) = {'chiy'};
M_.param_names_long(8) = {'chiy'};
M_.param_names(9) = {'rho'};
M_.param_names_tex(9) = {'rho'};
M_.param_names_long(9) = {'rho'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 10;
M_.param_nbr = 9;
M_.orig_endo_nbr = 10;
M_.aux_vars = [];
M_.heterogeneity_aggregates = {
};
M_.database = {};
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.Skew_e = zeros(0, 4);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = struct([]);
M_.surprise_shocks = struct([]);
M_.learnt_shocks = struct([]);
M_.learnt_endval = struct([]);
M_.shock_paths = struct([]);
M_.heteroskedastic_shocks.Qvalue_orig = struct([]);
M_.heteroskedastic_shocks.Qscale_orig = struct([]);
M_.matched_irfs = {};
M_.matched_irfs_weights = {};
M_.perfect_foresight_controlled_paths = struct([]);
options_.linear = true;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
options_.ramsey_policy = false;
options_.discretionary_policy = false;
M_.nonzero_hessian_eqs = [];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.eq_nbr = 10;
M_.ramsey_orig_eq_nbr = 0;
M_.ramsey_orig_endo_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 0 6 16;
 1 7 0;
 0 8 17;
 0 9 0;
 2 10 0;
 0 11 0;
 0 12 0;
 3 13 18;
 4 14 0;
 5 15 0;]';
M_.nstatic = 3;
M_.nfwrd   = 2;
M_.npred   = 4;
M_.nboth   = 1;
M_.nsfwrd   = 3;
M_.nspred   = 5;
M_.ndynamic   = 7;
M_.dynamic_tmp_nbr = [0; 0; 0; 0; ];
M_.equations_tags = {
  1 , 'name' , 'gdp' ;
  2 , 'name' , 'rmc' ;
  3 , 'name' , 'nmc' ;
  4 , 'name' , 'rwage' ;
  5 , 'name' , 'infl' ;
  6 , 'name' , '6' ;
  7 , 'name' , 'nomint' ;
  8 , 'name' , 'tot' ;
  9 , 'name' , 'h1' ;
  10 , 'name' , 'cpi' ;
};
M_.mapping.infl.eqidx = [5 6 7 ];
M_.mapping.cpi.eqidx = [3 5 10 ];
M_.mapping.gdp.eqidx = [1 4 6 7 ];
M_.mapping.employ.eqidx = [1 4 ];
M_.mapping.nomint.eqidx = [6 7 ];
M_.mapping.rwage.eqidx = [2 4 ];
M_.mapping.rmc.eqidx = [2 3 ];
M_.mapping.nmc.eqidx = [3 9 10 ];
M_.mapping.tot.eqidx = [1 2 8 ];
M_.mapping.h1.eqidx = [9 10 ];
M_.mapping.totsh.eqidx = [8 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.block_structure.time_recursive = false;
M_.block_structure.block(1).Simulation_Type = 1;
M_.block_structure.block(1).endo_nbr = 1;
M_.block_structure.block(1).mfs = 1;
M_.block_structure.block(1).equation = [ 8];
M_.block_structure.block(1).variable = [ 9];
M_.block_structure.block(1).is_linear = true;
M_.block_structure.block(1).bytecode_jacob_cols_to_sparse = [1 2 ];
M_.block_structure.block(2).Simulation_Type = 8;
M_.block_structure.block(2).endo_nbr = 9;
M_.block_structure.block(2).mfs = 7;
M_.block_structure.block(2).equation = [ 4 2 1 7 9 10 3 5 6];
M_.block_structure.block(2).variable = [ 6 7 4 5 10 2 8 1 3];
M_.block_structure.block(2).is_linear = true;
M_.block_structure.block(2).bytecode_jacob_cols_to_sparse = [2 3 4 5 0 0 8 9 10 11 12 13 14 19 20 21 ];
M_.block_structure.block(1).g1_sparse_rowval = int32([]);
M_.block_structure.block(1).g1_sparse_colval = int32([]);
M_.block_structure.block(1).g1_sparse_colptr = int32([]);
M_.block_structure.block(2).g1_sparse_rowval = int32([2 4 4 6 4 1 5 2 7 3 4 5 6 4 5 2 6 1 2 5 7 3 7 7 ]);
M_.block_structure.block(2).g1_sparse_colval = int32([2 3 4 4 5 8 8 9 9 10 11 11 11 12 12 13 13 14 14 14 14 19 20 21 ]);
M_.block_structure.block(2).g1_sparse_colptr = int32([1 1 2 3 5 6 6 6 8 10 11 14 16 18 22 22 22 22 22 23 24 25 ]);
M_.block_structure.variable_reordered = [ 9 6 7 4 5 10 2 8 1 3];
M_.block_structure.equation_reordered = [ 8 4 2 1 7 9 10 3 5 6];
M_.block_structure.incidence(1).lead_lag = -1;
M_.block_structure.incidence(1).sparse_IM = [
 5 2;
 7 5;
 8 9;
 10 2;
 10 8;
 10 10;
];
M_.block_structure.incidence(2).lead_lag = 0;
M_.block_structure.incidence(2).sparse_IM = [
 1 3;
 1 4;
 1 9;
 2 6;
 2 7;
 2 9;
 3 2;
 3 7;
 3 8;
 4 3;
 4 4;
 4 6;
 5 1;
 5 2;
 6 3;
 6 5;
 7 1;
 7 3;
 7 5;
 8 9;
 9 10;
 10 2;
 10 8;
];
M_.block_structure.incidence(3).lead_lag = 1;
M_.block_structure.incidence(3).sparse_IM = [
 6 1;
 6 3;
 9 8;
];
M_.block_structure.dyn_tmp_nbr = 0;
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
[~, ~, M_.state_var] = set_state_space(struct(), M_);
oo_.steady_state = zeros(10, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(9, 1);
M_.endo_trends = struct('deflator', cell(10, 1), 'log_deflator', cell(10, 1), 'growth_factor', cell(10, 1), 'log_growth_factor', cell(10, 1));
M_.dynamic_g1_sparse_rowval = int32([5 10 7 10 8 10 5 7 3 5 10 1 4 6 7 1 4 6 7 2 4 2 3 3 10 1 2 8 9 6 6 9 8 ]);
M_.dynamic_g1_sparse_colval = int32([2 2 5 8 9 10 11 11 12 12 12 13 13 13 13 14 14 15 15 16 16 17 17 18 18 19 19 19 20 21 23 28 31 ]);
M_.dynamic_g1_sparse_colptr = int32([1 1 3 3 3 4 4 4 5 6 7 9 12 16 18 20 22 24 26 29 30 31 31 32 32 32 32 32 33 33 33 34 ]);
M_.dynamic_g2_sparse_indices = int32([]);
M_.lhs = {
'gdp'; 
'rmc'; 
'nmc'; 
'rwage'; 
'infl'; 
'gdp'; 
'nomint'; 
'tot'; 
'h1'; 
'cpi'; 
};
M_.dynamic_mcp_equations_reordering = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; ];
M_.static_tmp_nbr = [0; 0; 0; 0; ];
M_.block_structure_stat.block(1).Simulation_Type = 1;
M_.block_structure_stat.block(1).endo_nbr = 1;
M_.block_structure_stat.block(1).mfs = 1;
M_.block_structure_stat.block(1).equation = [ 5];
M_.block_structure_stat.block(1).variable = [ 1];
M_.block_structure_stat.block(2).Simulation_Type = 3;
M_.block_structure_stat.block(2).endo_nbr = 1;
M_.block_structure_stat.block(2).mfs = 1;
M_.block_structure_stat.block(2).equation = [ 8];
M_.block_structure_stat.block(2).variable = [ 9];
M_.block_structure_stat.block(3).Simulation_Type = 6;
M_.block_structure_stat.block(3).endo_nbr = 2;
M_.block_structure_stat.block(3).mfs = 2;
M_.block_structure_stat.block(3).equation = [ 6 7];
M_.block_structure_stat.block(3).variable = [ 5 3];
M_.block_structure_stat.block(4).Simulation_Type = 3;
M_.block_structure_stat.block(4).endo_nbr = 1;
M_.block_structure_stat.block(4).mfs = 1;
M_.block_structure_stat.block(4).equation = [ 1];
M_.block_structure_stat.block(4).variable = [ 4];
M_.block_structure_stat.block(5).Simulation_Type = 1;
M_.block_structure_stat.block(5).endo_nbr = 2;
M_.block_structure_stat.block(5).mfs = 2;
M_.block_structure_stat.block(5).equation = [ 4 2];
M_.block_structure_stat.block(5).variable = [ 6 7];
M_.block_structure_stat.block(6).Simulation_Type = 6;
M_.block_structure_stat.block(6).endo_nbr = 3;
M_.block_structure_stat.block(6).mfs = 3;
M_.block_structure_stat.block(6).equation = [ 3 9 10];
M_.block_structure_stat.block(6).variable = [ 2 8 10];
M_.block_structure_stat.variable_reordered = [ 1 9 5 3 4 6 7 2 8 10];
M_.block_structure_stat.equation_reordered = [ 5 8 6 7 1 4 2 3 9 10];
M_.block_structure_stat.incidence.sparse_IM = [
 1 3;
 1 4;
 1 9;
 2 6;
 2 7;
 2 9;
 3 2;
 3 7;
 3 8;
 4 3;
 4 4;
 4 6;
 5 1;
 6 1;
 6 5;
 7 1;
 7 3;
 7 5;
 8 9;
 9 8;
 9 10;
 10 2;
 10 8;
 10 10;
];
M_.block_structure_stat.tmp_nbr = 0;
M_.block_structure_stat.block(1).g1_sparse_rowval = int32([]);
M_.block_structure_stat.block(1).g1_sparse_colval = int32([]);
M_.block_structure_stat.block(1).g1_sparse_colptr = int32([]);
M_.block_structure_stat.block(2).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(3).g1_sparse_rowval = int32([1 2 2 ]);
M_.block_structure_stat.block(3).g1_sparse_colval = int32([1 1 2 ]);
M_.block_structure_stat.block(3).g1_sparse_colptr = int32([1 3 4 ]);
M_.block_structure_stat.block(4).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(4).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(4).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(5).g1_sparse_rowval = int32([]);
M_.block_structure_stat.block(5).g1_sparse_colval = int32([]);
M_.block_structure_stat.block(5).g1_sparse_colptr = int32([]);
M_.block_structure_stat.block(6).g1_sparse_rowval = int32([1 3 1 2 3 2 3 ]);
M_.block_structure_stat.block(6).g1_sparse_colval = int32([1 1 2 2 2 3 3 ]);
M_.block_structure_stat.block(6).g1_sparse_colptr = int32([1 3 6 8 ]);
M_.static_g1_sparse_rowval = int32([5 6 7 3 10 1 4 7 1 4 6 7 2 4 2 3 3 9 10 1 2 8 9 10 ]);
M_.static_g1_sparse_colval = int32([1 1 1 2 2 3 3 3 4 4 5 5 6 6 7 7 8 8 8 9 9 9 10 10 ]);
M_.static_g1_sparse_colptr = int32([1 4 6 9 11 13 15 17 20 23 25 ]);
M_.static_mcp_equations_reordering = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; ];
M_.params(1) = 0.15;
alph = M_.params(1);
rbar      = 2;      
M_.params(4) = 0.5;
intsub = M_.params(4);
M_.params(5) = 3;
frisch = M_.params(5);
M_.params(3) = 0.91;
lambda_si = M_.params(3);
M_.params(6) = 0.9;
phi = M_.params(6);
M_.params(7) = 3;
chipi = M_.params(7);
M_.params(8) = 0.5;
chiy = M_.params(8);
M_.params(9) = 0.95;
rho = M_.params(9);
M_.params(2) = (1/(1+rbar/100))^0.08333333333333333;
bet = M_.params(2);
%
% SHOCKS instructions
%
M_.Sigma_e(1, 1) = (100)^2;
options_.irf = 50;
options_.order = 1;
var_list_ = {'infl';'gdp';'tot';'nomint'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'oo_recursive_', '-append');
end
if exist('options_mom_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'inflation_si_kw_results.mat'], 'options_mom_', '-append');
end
disp('Note: 1 warning(s) encountered in the preprocessor')
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
