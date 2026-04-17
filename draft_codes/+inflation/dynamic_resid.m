function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(10, 1);
    residual(1) = (y(14)) - (y(15)-params(1)*y(20));
    residual(2) = (y(18)) - (params(1)*y(20)+y(17));
    residual(3) = (y(19)) - (y(18)+y(12));
    residual(4) = (y(17)) - (y(14)*1/params(4)+y(15)*1/params(5));
    residual(5) = (y(11)) - (12*(y(12)-y(2)));
    residual(6) = (y(12)) - (y(2)*params(3)+(1-params(3))*y(13));
    residual(7) = (y(13)) - (params(3)*params(2)*y(23)+y(19)*(1-params(3)*params(2)));
    residual(8) = (y(14)) - (y(24)-params(4)*(y(16)/12-y(21)/12));
    residual(9) = (y(16)) - (params(6)*y(6)+(1-params(6))*(y(11)*params(7)+y(14)*12*params(8)));
    residual(10) = (y(20)) - (params(9)*y(10)+x(1));
end
