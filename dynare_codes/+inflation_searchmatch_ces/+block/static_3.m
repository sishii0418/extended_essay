function [y, T, residual, g1] = static_3(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  residual(1)=(y(13))-((1-params(1))*y(11)+params(1)*y(16));
  residual(2)=(y(11))-(y(12)*(1-params(4)));
  residual(3)=(y(18))-((y(11)-y(16))*params(1)*params(10));
  residual(4)=(params(5)*y(9))-((1-params(2)*params(6))*(y(13)+y(18)-y(11))+y(9)*params(5)*params(2)*params(6));
  residual(5)=(y(12))-(params(5)*y(9)+params(5)*(y(13)+y(18)));
if nargout > 3
    g1_v = NaN(14, 1);
g1_v(1)=1;
g1_v(2)=(-(1-params(2)*params(6)));
g1_v(3)=(-params(5));
g1_v(4)=(-(1-params(1)));
g1_v(5)=1;
g1_v(6)=(-(params(1)*params(10)));
g1_v(7)=1-params(2)*params(6);
g1_v(8)=1;
g1_v(9)=(-(1-params(2)*params(6)));
g1_v(10)=(-params(5));
g1_v(11)=params(5)-params(5)*params(2)*params(6);
g1_v(12)=(-params(5));
g1_v(13)=(-(1-params(4)));
g1_v(14)=1;
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 5);
end
end
