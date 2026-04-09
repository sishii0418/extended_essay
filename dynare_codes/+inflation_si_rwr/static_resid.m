function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_si_rwr.static_resid_tt(y, x, params, T_order, T);
residual = NaN(11, 1);
    residual(1) = (y(3)) - (y(4)-params(1)*y(10));
    residual(2) = (y(8)) - (params(1)*y(10)+y(6));
    residual(3) = (y(9)) - (y(8)+y(2));
residual(4) = y(1);
    residual(5) = (y(3)) - (y(3)-params(5)*(y(5)/12-y(1)/12));
    residual(6) = (y(5)) - (y(5)*params(7)+(1-params(7))*(y(1)*params(8)+y(3)*12*params(9)));
    residual(7) = (y(10)) - (y(10)*params(10)+x(1));
    residual(8) = (y(11)) - (y(9));
    residual(9) = (y(2)) - (y(9)*(1-params(3))+params(3)*(y(2)+y(11)-y(9)));
    residual(10) = (y(7)) - (y(3)*1/params(5)+y(4)*1/params(6));
    residual(11) = (y(6)) - (y(6)*params(4)+y(7)*(1-params(4)));
end
