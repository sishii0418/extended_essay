function [y, T, residual, g1] = dynamic_7(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  y(20)=y(21)+params(9)*y(24);
  residual(1)=(y(31))-(params(11)*y(15)+(1-params(11))*(y(17)*params(12)+12*params(13)*y(20)));
  residual(2)=(y(21))-(y(37)-params(10)*(y(31)/12-y(33)/12));
if nargout > 3
    g1_v = NaN(6, 1);
g1_v(1)=(-params(11));
g1_v(2)=1;
g1_v(3)=params(10)*0.08333333333333333;
g1_v(4)=(-((1-params(11))*12*params(13)));
g1_v(5)=1;
g1_v(6)=(-1);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 6);
end
end
