function [y, T, residual, g1] = static_5(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(7))-((-(params(6)*params(7)/params(8)))*y(6));
  residual(2)=(y(8))-(y(7)+y(9));
  residual(3)=(y(6))-(params(6)*y(6)+(1-params(6))*(y(8)+y(10)));
if nargout > 3
    g1_v = NaN(6, 1);
g1_v(1)=params(6)*params(7)/params(8);
g1_v(2)=1-params(6);
g1_v(3)=1;
g1_v(4)=(-1);
g1_v(5)=1;
g1_v(6)=(-(1-params(6)));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
