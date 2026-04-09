function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_si_kw.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(10, 1);
    residual(1) = (y(13)) - (y(14)-params(1)*y(19));
    residual(2) = (y(17)) - (params(1)*y(19)+y(16));
    residual(3) = (y(18)) - (y(17)+y(12));
    residual(4) = (y(16)) - (y(13)*1/params(4)+y(14)*1/params(5));
    residual(5) = (y(11)) - (12*(y(12)-y(2)));
    residual(6) = (y(13)) - (y(23)-params(4)*(y(15)/12-y(21)/12));
    residual(7) = (y(15)) - (params(6)*y(5)+(1-params(6))*(y(11)*params(7)+y(13)*12*params(8)));
    residual(8) = (y(19)) - (params(9)*y(9)+x(1));
    residual(9) = (y(20)) - (y(28));
    residual(10) = (y(12)) - (y(18)*(1-params(3))+params(3)*(y(2)+y(10)-y(8)));
end
