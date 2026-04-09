function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  y(18)=y(15)*1/params(4)+y(16)*1/params(5);
  y(19)=params(1)*y(21)+y(18);
  y(20)=y(19)+y(13);
  residual(1)=(y(15))-(y(16)-params(1)*y(21));
  residual(2)=(y(13))-(y(2)*params(3)+(1-params(3))*y(14));
  residual(3)=(y(15))-(1/(1+params(13))*y(26)+params(13)/(1+params(13))*y(4)-(1-params(13))/(params(4)*(1+params(13)))*(y(17)/12-y(23)/12));
  residual(4)=(y(17))-(params(6)*y(6)+(1-params(6))*(y(12)*params(7)+y(15)*12*params(8)));
  residual(5)=(y(12))-(12*(y(13)-y(2)));
  residual(6)=(y(14))-(params(3)*params(2)*y(25)+y(20)*(1-params(3)*params(2))+params(12)*y(22));
if nargout > 3
    g1_v = NaN(22, 1);
g1_v(1)=(-params(3));
g1_v(2)=12;
g1_v(3)=(-params(6));
g1_v(4)=(-(params(13)/(1+params(13))));
g1_v(5)=(-1);
g1_v(6)=(-(1/params(5)*(1-params(3)*params(2))));
g1_v(7)=1;
g1_v(8)=(-12);
g1_v(9)=(-(1-params(3)*params(2)));
g1_v(10)=(1-params(13))/(params(4)*(1+params(13)))*0.08333333333333333;
g1_v(11)=1;
g1_v(12)=1;
g1_v(13)=1;
g1_v(14)=(-((1-params(6))*12*params(8)));
g1_v(15)=(-(1/params(4)*(1-params(3)*params(2))));
g1_v(16)=(-((1-params(6))*params(7)));
g1_v(17)=1;
g1_v(18)=(-(1-params(3)));
g1_v(19)=1;
g1_v(20)=(-(1/(1+params(13))));
g1_v(21)=(1-params(13))/(params(4)*(1+params(13)))*(-0.08333333333333333);
g1_v(22)=(-(params(3)*params(2)));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 18);
end
end
