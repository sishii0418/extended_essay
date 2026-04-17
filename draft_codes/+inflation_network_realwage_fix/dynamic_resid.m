function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_network_realwage_fix.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(13, 1);
    residual(1) = (y(17)) - (y(18)-params(1)*params(5)*y(23));
    residual(2) = (y(21)) - (params(7)*(y(24)-y(15))+(1-params(7))*y(20));
    residual(3) = (y(22)) - (y(21)+y(15));
    residual(4) = (y(20)) - (params(9)*y(7)+(1-params(9))*(y(17)*1/params(10)+y(18)*1/params(11)));
    residual(5) = (y(14)) - (12*(y(15)-y(2)));
    residual(6) = (y(26)) - (12*(y(24)-y(11)));
    residual(7) = (y(15)) - (y(2)*params(3)+(1-params(3))*y(16));
    residual(8) = (y(16)) - (params(3)*params(2)*params(8)*y(29)+y(22)*(1-params(3)*params(2)*params(8)));
    residual(9) = (y(24)) - (y(11)*params(4)+(1-params(4))*y(25));
    residual(10) = (y(25)) - (params(2)*params(4)*y(38)+(1-params(2)*params(4))*(y(15)+y(20)+params(1)*y(23)));
    residual(11) = (y(17)) - (y(30)-params(10)*(y(19)/12-y(27)/12));
    residual(12) = (y(19)) - (params(12)*y(6)+(1-params(12))*(y(14)*params(13)+y(17)*12*params(14)));
    residual(13) = (y(23)) - (params(15)*y(10)+x(1));
end
