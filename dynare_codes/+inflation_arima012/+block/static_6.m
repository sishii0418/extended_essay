function [y, T, residual, g1] = static_6(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(2))-(y(2)*params(3)+(1-params(3))*y(3));
  residual(2)=(y(3))-(y(3)*params(3)*params(2)+y(9)*(1-params(3)*params(2)));
  residual(3)=(y(9))-(y(8)+y(2));
if nargout > 3
    g1_v = NaN(6, 1);
g1_v(1)=1-params(3);
g1_v(2)=(-1);
g1_v(3)=(-(1-params(3)));
g1_v(4)=1-params(3)*params(2);
g1_v(5)=(-(1-params(3)*params(2)));
g1_v(6)=1;
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
