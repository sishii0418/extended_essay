function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_searchmatch.static_resid_tt(y, x, params, T_order, T);
residual = NaN(16, 1);
    residual(1) = (y(13)) - (y(11)+params(1)*y(16));
    residual(2) = (y(14)) - (y(13)+y(2));
residual(3) = y(1);
    residual(4) = (y(2)) - (y(2)*params(3)+(1-params(3))*y(3));
    residual(5) = (y(3)) - (y(3)*params(3)*params(2)+y(14)*(1-params(3)*params(2)));
    residual(6) = (y(15)) - (y(15)*params(11)+(1-params(11))*(y(1)*params(12)+12*params(13)*y(4)));
    residual(7) = (y(5)) - (y(5)-params(10)*(y(15)/12-y(1)/12));
    residual(8) = (y(4)) - (y(5)+params(9)*y(8));
    residual(9) = (y(16)) - (y(16)*params(14)+x(1));
    residual(10) = (y(7)) - ((-(params(6)*params(7)/params(8)))*y(6));
    residual(11) = (y(10)) - ((-params(5))*y(9));
    residual(12) = (y(8)) - (y(7)+y(9));
    residual(13) = (y(6)) - (params(6)*y(6)+(1-params(6))*(y(8)+y(10)));
    residual(14) = (params(5)*y(9)) - ((1-params(2)*params(6))*(y(13)-y(11))+y(9)*params(5)*params(2)*params(6));
    residual(15) = (y(12)) - (params(5)*y(9)+y(13)*params(5));
    residual(16) = (y(11)) - (y(12)*(1-params(4)));
end
