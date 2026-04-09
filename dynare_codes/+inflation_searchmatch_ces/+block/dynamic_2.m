function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(4, 1);
  y(36)=(y(29)-y(34))*params(1)*params(10);
  residual(1)=(y(31))-((1-params(1))*y(29)+params(1)*y(34));
  residual(2)=(y(29))-(y(30)*(1-params(4)));
  residual(3)=(y(30))-(params(5)*y(27)+params(5)*(y(31)+y(36)));
  residual(4)=(params(5)*y(27))-((1-params(2)*params(6))*(y(31)+y(36)-y(29))+params(5)*params(2)*params(6)*y(45));
if nargout > 3
    g1_v = NaN(11, 1);
g1_v(1)=(-(1-params(1)));
g1_v(2)=1;
g1_v(3)=(-(params(1)*params(10)*params(5)));
g1_v(4)=(-((1-params(2)*params(6))*(params(1)*params(10)-1)));
g1_v(5)=(-(1-params(4)));
g1_v(6)=1;
g1_v(7)=1;
g1_v(8)=(-params(5));
g1_v(9)=(-(1-params(2)*params(6)));
g1_v(10)=(-params(5));
g1_v(11)=params(5);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 4, 4);
end
end
