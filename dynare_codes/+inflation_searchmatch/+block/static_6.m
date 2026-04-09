function [y, T, residual, g1] = static_6(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(15))-(y(15)*params(11)+(1-params(11))*(y(1)*params(12)+12*params(13)*y(4)));
  residual(2)=(y(5))-(y(5)-params(10)*(y(15)/12-y(1)/12));
  residual(3)=(y(4))-(y(5)+params(9)*y(8));
if nargout > 3
    g1_v = NaN(5, 1);
g1_v(1)=(-((1-params(11))*12*params(13)));
g1_v(2)=1;
g1_v(3)=1-params(11);
g1_v(4)=params(10)*0.08333333333333333;
g1_v(5)=(-1);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
