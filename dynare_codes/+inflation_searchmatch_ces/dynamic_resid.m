function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_searchmatch_ces.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(18, 1);
    residual(1) = (y(31)) - ((1-params(1))*y(29)+params(1)*y(34));
    residual(2) = (y(32)) - (y(31)+y(20));
    residual(3) = (y(19)) - (12*(y(20)-y(2)));
    residual(4) = (y(20)) - (y(2)*params(3)+(1-params(3))*y(21));
    residual(5) = (y(21)) - (params(3)*params(2)*y(39)+y(32)*(1-params(3)*params(2)));
    residual(6) = (y(33)) - (params(12)*y(15)+(1-params(12))*(y(19)*params(13)+12*params(14)*y(22)));
    residual(7) = (y(23)) - (y(41)-params(11)*(y(33)/12-y(37)/12));
    residual(8) = (y(22)) - (y(23)+params(9)*y(26));
    residual(9) = (y(34)) - (params(15)*y(16)+x(1));
    residual(10) = (y(35)) - (y(24)+params(10)*(y(29)-y(34)));
    residual(11) = (y(36)) - ((y(29)-y(34))*params(1)*params(10));
    residual(12) = (y(25)) - ((-(params(6)*params(7)/params(8)))*y(6));
    residual(13) = (y(28)) - ((-params(5))*y(27));
    residual(14) = (y(26)) - (y(25)+y(27));
    residual(15) = (y(24)) - (params(6)*y(6)+(1-params(6))*(y(26)+y(28)));
    residual(16) = (params(5)*y(27)) - ((1-params(2)*params(6))*(y(31)+y(36)-y(29))+params(5)*params(2)*params(6)*y(45));
    residual(17) = (y(30)) - (params(5)*y(27)+params(5)*(y(31)+y(36)));
    residual(18) = (y(29)) - (y(30)*(1-params(4)));
end
