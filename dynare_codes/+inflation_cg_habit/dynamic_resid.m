function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(1, 1);
end
[T_order, T] = inflation_cg_habit.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(11, 1);
    residual(1) = (y(15)) - (y(16)-params(1)*y(21));
    residual(2) = (y(19)) - (params(1)*y(21)+y(18));
    residual(3) = (y(20)) - (y(19)+y(13));
    residual(4) = (y(18)) - (y(15)*1/params(4)+y(16)*1/params(5));
    residual(5) = (y(12)) - (12*(y(13)-y(2)));
    residual(6) = (y(13)) - (y(2)*params(3)+(1-params(3))*y(14));
    residual(7) = (y(14)) - (params(3)*params(2)*y(25)+y(20)*(1-params(3)*params(2))+params(12)*y(22));
    residual(8) = (y(15)) - (1/(1+params(13))*y(26)+params(13)/(1+params(13))*y(4)-T(1)*(y(17)/12-y(23)/12));
    residual(9) = (y(17)) - (params(6)*y(6)+(1-params(6))*(y(12)*params(7)+y(15)*12*params(8)));
    residual(10) = (y(21)) - (params(9)*y(10)+x(1));
    residual(11) = (y(22)) - (params(10)*y(11)+y(21)*params(11));
end
