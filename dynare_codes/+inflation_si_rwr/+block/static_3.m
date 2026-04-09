function [y, T, residual, g1] = static_3(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  residual(1)=(y(3))-(y(3)-params(5)*(y(5)/12-y(1)/12));
  residual(2)=(y(5))-(y(5)*params(7)+(1-params(7))*(y(1)*params(8)+y(3)*12*params(9)));
if nargout > 3
    g1_v = NaN(3, 1);
g1_v(1)=params(5)*0.08333333333333333;
g1_v(2)=1-params(7);
g1_v(3)=(-((1-params(7))*12*params(9)));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 2);
end
end
