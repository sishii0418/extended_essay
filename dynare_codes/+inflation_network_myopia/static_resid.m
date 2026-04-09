function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_network_myopia.static_resid_tt(y, x, params, T_order, T);
residual = NaN(13, 1);
    residual(1) = (y(4)) - (y(5)-params(1)*y(10));
    residual(2) = (y(8)) - (params(5)*(y(11)-y(2))+(1-params(5))*y(7));
    residual(3) = (y(9)) - (y(8)+y(2));
    residual(4) = (y(7)) - (y(4)*1/params(7)+y(5)*1/params(8));
residual(5) = y(1);
residual(6) = y(13);
    residual(7) = (y(2)) - (y(2)*params(3)+(1-params(3))*y(3));
    residual(8) = (y(3)) - (y(3)*params(3)*params(2)*params(6)+y(9)*(1-params(3)*params(2)*params(6)));
    residual(9) = (y(11)) - (y(11)*params(4)+(1-params(4))*y(12));
    residual(10) = (y(12)) - (y(12)*params(2)*params(4)+(1-params(2)*params(4))*(params(1)*y(10)+y(2)+y(7)));
    residual(11) = (y(4)) - (y(4)-params(7)*(y(6)/12-y(1)/12));
    residual(12) = (y(6)) - (y(6)*params(9)+(1-params(9))*(y(1)*params(10)+y(4)*12*params(11)));
    residual(13) = (y(10)) - (y(10)*params(12)+x(1));
end
