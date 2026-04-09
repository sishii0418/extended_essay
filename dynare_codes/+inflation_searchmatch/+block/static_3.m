function [y, T, residual, g1] = static_3(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(4, 1);
  residual(1)=(y(13))-(y(11)+params(1)*y(16));
  residual(2)=(params(5)*y(9))-((1-params(2)*params(6))*(y(13)-y(11))+y(9)*params(5)*params(2)*params(6));
  residual(3)=(y(12))-(params(5)*y(9)+y(13)*params(5));
  residual(4)=(y(11))-(y(12)*(1-params(4)));
if nargout > 3
    g1_v = NaN(10, 1);
g1_v(1)=1;
g1_v(2)=(-(1-params(2)*params(6)));
g1_v(3)=(-params(5));
g1_v(4)=params(5)-params(5)*params(2)*params(6);
g1_v(5)=(-params(5));
g1_v(6)=1;
g1_v(7)=(-(1-params(4)));
g1_v(8)=(-1);
g1_v(9)=1-params(2)*params(6);
g1_v(10)=1;
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 4, 4);
end
end
