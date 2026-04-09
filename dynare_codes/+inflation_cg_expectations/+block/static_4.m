function [y, T, residual, g1] = static_4(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  residual(1)=(y(4))-(y(4)-params(4)*(y(6)/12-y(1)/12));
  residual(2)=(y(6))-(y(6)*params(6)+(1-params(6))*(y(1)*params(7)+y(4)*12*params(8)));
if nargout > 3
    g1_v = NaN(3, 1);
g1_v(1)=params(4)*0.08333333333333333;
g1_v(2)=1-params(6);
g1_v(3)=(-((1-params(6))*12*params(8)));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 2);
end
end
