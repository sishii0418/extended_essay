function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(1, 1);
end
[T_order, T] = inflation_cg_habit.static_resid_tt(y, x, params, T_order, T);
residual = NaN(11, 1);
    residual(1) = (y(4)) - (y(5)-params(1)*y(10));
    residual(2) = (y(8)) - (params(1)*y(10)+y(7));
    residual(3) = (y(9)) - (y(8)+y(2));
    residual(4) = (y(7)) - (y(4)*1/params(4)+y(5)*1/params(5));
residual(5) = y(1);
    residual(6) = (y(2)) - (y(2)*params(3)+(1-params(3))*y(3));
    residual(7) = (y(3)) - (y(3)*params(3)*params(2)+y(9)*(1-params(3)*params(2))+params(12)*y(11));
    residual(8) = (y(4)) - (y(4)*1/(1+params(13))+y(4)*params(13)/(1+params(13))-T(1)*(y(6)/12-y(1)/12));
    residual(9) = (y(6)) - (y(6)*params(6)+(1-params(6))*(y(1)*params(7)+y(4)*12*params(8)));
    residual(10) = (y(10)) - (y(10)*params(9)+x(1));
    residual(11) = (y(11)) - (y(11)*params(10)+y(10)*params(11));
end
