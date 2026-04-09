function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  y(29)=y(27)+params(1)*y(32);
  residual(1)=(params(5)*y(25))-((1-params(2)*params(6))*(y(29)-y(27))+params(5)*params(2)*params(6)*y(41));
  residual(2)=(y(27))-(y(28)*(1-params(4)));
  residual(3)=(y(28))-(params(5)*y(25)+y(29)*params(5));
if nargout > 3
    g1_v = NaN(6, 1);
g1_v(1)=1;
g1_v(2)=(-params(5));
g1_v(3)=(-(1-params(4)));
g1_v(4)=1;
g1_v(5)=params(5);
g1_v(6)=(-params(5));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
