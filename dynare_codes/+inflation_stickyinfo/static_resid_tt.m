function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 12
    T = [T; NaN(12 - size(T, 1), 1)];
end
T(1) = (1-params(3))/(1-params(3)^13);
T(2) = params(3)^2;
T(3) = params(3)^3;
T(4) = params(3)^4;
T(5) = params(3)^5;
T(6) = params(3)^6;
T(7) = params(3)^7;
T(8) = params(3)^8;
T(9) = params(3)^9;
T(10) = params(3)^10;
T(11) = params(3)^11;
T(12) = params(3)^12;
end
