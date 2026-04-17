function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  y(17)=y(14)*1/params(4)+y(15)*1/params(5);
  y(18)=params(1)*y(20)+y(17);
  y(19)=y(18)+y(12);
  residual(1)=(y(14))-(y(15)-params(1)*y(20));
  residual(2)=(y(12))-(y(2)*params(3)+(1-params(3))*y(13));
  residual(3)=(y(16))-(params(6)*y(6)+(1-params(6))*(y(11)*params(7)+y(14)*12*params(8)));
  residual(4)=(y(11))-(12*(y(12)-y(2)));
  residual(5)=(y(13))-(params(3)*params(2)*y(23)+y(19)*(1-params(3)*params(2)));
  residual(6)=(y(14))-(y(24)-params(4)*(y(16)/12-y(21)/12));
if nargout > 3
    g1_v = NaN(21, 1);
g1_v(1)=(-params(3));
g1_v(2)=12;
g1_v(3)=(-params(6));
g1_v(4)=(-1);
g1_v(5)=(-(1/params(5)*(1-params(3)*params(2))));
g1_v(6)=1;
g1_v(7)=(-12);
g1_v(8)=(-(1-params(3)*params(2)));
g1_v(9)=1;
g1_v(10)=params(4)*0.08333333333333333;
g1_v(11)=(-((1-params(6))*params(7)));
g1_v(12)=1;
g1_v(13)=(-(1-params(3)));
g1_v(14)=1;
g1_v(15)=1;
g1_v(16)=(-((1-params(6))*12*params(8)));
g1_v(17)=(-(1/params(4)*(1-params(3)*params(2))));
g1_v(18)=1;
g1_v(19)=params(4)*(-0.08333333333333333);
g1_v(20)=(-(params(3)*params(2)));
g1_v(21)=(-1);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 18);
end
end
