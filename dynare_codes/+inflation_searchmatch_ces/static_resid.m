function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_searchmatch_ces.static_resid_tt(y, x, params, T_order, T);
residual = NaN(18, 1);
    residual(1) = (y(13)) - ((1-params(1))*y(11)+params(1)*y(16));
    residual(2) = (y(14)) - (y(13)+y(2));
residual(3) = y(1);
    residual(4) = (y(2)) - (y(2)*params(3)+(1-params(3))*y(3));
    residual(5) = (y(3)) - (y(3)*params(3)*params(2)+y(14)*(1-params(3)*params(2)));
    residual(6) = (y(15)) - (y(15)*params(12)+(1-params(12))*(y(1)*params(13)+12*params(14)*y(4)));
    residual(7) = (y(5)) - (y(5)-params(11)*(y(15)/12-y(1)/12));
    residual(8) = (y(4)) - (y(5)+params(9)*y(8));
    residual(9) = (y(16)) - (y(16)*params(15)+x(1));
    residual(10) = (y(17)) - (y(6)+params(10)*(y(11)-y(16)));
    residual(11) = (y(18)) - ((y(11)-y(16))*params(1)*params(10));
    residual(12) = (y(7)) - (y(6)*(-(params(6)*params(7)/params(8))));
    residual(13) = (y(10)) - ((-params(5))*y(9));
    residual(14) = (y(8)) - (y(7)+y(9));
    residual(15) = (y(6)) - (y(6)*params(6)+(1-params(6))*(y(8)+y(10)));
    residual(16) = (params(5)*y(9)) - ((1-params(2)*params(6))*(y(13)+y(18)-y(11))+y(9)*params(5)*params(2)*params(6));
    residual(17) = (y(12)) - (params(5)*y(9)+params(5)*(y(13)+y(18)));
    residual(18) = (y(11)) - (y(12)*(1-params(4)));
end
