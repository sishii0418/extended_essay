function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_searchmatch.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(16, 1);
    residual(1) = (y(29)) - (y(27)+params(1)*y(32));
    residual(2) = (y(30)) - (y(29)+y(18));
    residual(3) = (y(17)) - (12*(y(18)-y(2)));
    residual(4) = (y(18)) - (y(2)*params(3)+(1-params(3))*y(19));
    residual(5) = (y(19)) - (params(3)*params(2)*y(35)+y(30)*(1-params(3)*params(2)));
    residual(6) = (y(31)) - (params(11)*y(15)+(1-params(11))*(y(17)*params(12)+12*params(13)*y(20)));
    residual(7) = (y(21)) - (y(37)-params(10)*(y(31)/12-y(33)/12));
    residual(8) = (y(20)) - (y(21)+params(9)*y(24));
    residual(9) = (y(32)) - (params(14)*y(16)+x(1));
    residual(10) = (y(23)) - ((-(params(6)*params(7)/params(8)))*y(6));
    residual(11) = (y(26)) - ((-params(5))*y(25));
    residual(12) = (y(24)) - (y(23)+y(25));
    residual(13) = (y(22)) - (params(6)*y(6)+(1-params(6))*(y(24)+y(26)));
    residual(14) = (params(5)*y(25)) - ((1-params(2)*params(6))*(y(29)-y(27))+params(5)*params(2)*params(6)*y(41));
    residual(15) = (y(28)) - (params(5)*y(25)+y(29)*params(5));
    residual(16) = (y(27)) - (y(28)*(1-params(4)));
end
