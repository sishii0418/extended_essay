function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_realwage.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(12, 1);
    residual(1) = (y(16)) - (y(17)-params(1)*y(23));
    residual(2) = (y(21)) - (params(1)*y(23)+y(19));
    residual(3) = (y(22)) - (y(21)+y(14));
    residual(4) = (y(13)) - (12*(y(14)-y(2)));
    residual(5) = (y(14)) - (y(2)*params(3)+(1-params(3))*y(15));
    residual(6) = (y(15)) - (params(3)*params(2)*y(27)+y(22)*(1-params(3)*params(2)));
    residual(7) = (y(16)) - (y(28)-params(5)*(y(18)/12-y(25)/12));
    residual(8) = (y(18)) - (params(7)*y(6)+(1-params(7))*(y(13)*params(8)+y(16)*12*params(9)));
    residual(9) = (y(23)) - (params(10)*y(11)+x(1));
    residual(10) = (y(20)) - (y(16)*1/params(5)+y(17)*1/params(6));
    residual(11) = (y(19)) - (params(4)*y(7)+y(20)*(1-params(4)));
    residual(12) = (y(24)) - (y(19)+y(14));
end
