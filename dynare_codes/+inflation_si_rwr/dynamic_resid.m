function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = inflation_si_rwr.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(11, 1);
    residual(1) = (y(14)) - (y(15)-params(1)*y(21));
    residual(2) = (y(19)) - (params(1)*y(21)+y(17));
    residual(3) = (y(20)) - (y(19)+y(13));
    residual(4) = (y(12)) - (12*(y(13)-y(2)));
    residual(5) = (y(14)) - (y(25)-params(5)*(y(16)/12-y(23)/12));
    residual(6) = (y(16)) - (params(7)*y(5)+(1-params(7))*(y(12)*params(8)+y(14)*12*params(9)));
    residual(7) = (y(21)) - (params(10)*y(10)+x(1));
    residual(8) = (y(22)) - (y(31));
    residual(9) = (y(13)) - (y(20)*(1-params(3))+params(3)*(y(2)+y(11)-y(9)));
    residual(10) = (y(18)) - (y(14)*1/params(5)+y(15)*1/params(6));
    residual(11) = (y(17)) - (params(4)*y(6)+y(18)*(1-params(4)));
end
