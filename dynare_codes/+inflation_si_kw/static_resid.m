function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_si_kw.static_resid_tt(y, x, params, T_order, T);
residual = NaN(10, 1);
    residual(1) = (y(3)) - (y(4)-params(1)*y(9));
    residual(2) = (y(7)) - (params(1)*y(9)+y(6));
    residual(3) = (y(8)) - (y(7)+y(2));
    residual(4) = (y(6)) - (y(3)*1/params(4)+y(4)*1/params(5));
residual(5) = y(1);
    residual(6) = (y(3)) - (y(3)-params(4)*(y(5)/12-y(1)/12));
    residual(7) = (y(5)) - (y(5)*params(6)+(1-params(6))*(y(1)*params(7)+y(3)*12*params(8)));
    residual(8) = (y(9)) - (y(9)*params(9)+x(1));
    residual(9) = (y(10)) - (y(8));
    residual(10) = (y(2)) - (y(8)*(1-params(3))+params(3)*(y(2)+y(10)-y(8)));
end
