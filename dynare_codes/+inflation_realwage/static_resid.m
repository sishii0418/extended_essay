function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_realwage.static_resid_tt(y, x, params, T_order, T);
residual = NaN(12, 1);
    residual(1) = (y(4)) - (y(5)-params(1)*y(11));
    residual(2) = (y(9)) - (params(1)*y(11)+y(7));
    residual(3) = (y(10)) - (y(9)+y(2));
residual(4) = y(1);
    residual(5) = (y(2)) - (y(2)*params(3)+(1-params(3))*y(3));
    residual(6) = (y(3)) - (y(3)*params(3)*params(2)+y(10)*(1-params(3)*params(2)));
    residual(7) = (y(4)) - (y(4)-params(5)*(y(6)/12-y(1)/12));
    residual(8) = (y(6)) - (y(6)*params(7)+(1-params(7))*(y(1)*params(8)+y(4)*12*params(9)));
    residual(9) = (y(11)) - (y(11)*params(10)+x(1));
    residual(10) = (y(8)) - (y(4)*1/params(5)+y(5)*1/params(6));
    residual(11) = (y(7)) - (y(7)*params(4)+y(8)*(1-params(4)));
    residual(12) = (y(12)) - (y(7)+y(2));
end
