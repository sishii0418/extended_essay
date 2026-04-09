function [y, T, residual, g1] = dynamic_7(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  y(22)=y(23)+params(9)*y(26);
  residual(1)=(y(33))-(params(12)*y(15)+(1-params(12))*(y(19)*params(13)+12*params(14)*y(22)));
  residual(2)=(y(23))-(y(41)-params(11)*(y(33)/12-y(37)/12));
if nargout > 3
    g1_v = NaN(6, 1);
g1_v(1)=(-params(12));
g1_v(2)=1;
g1_v(3)=params(11)*0.08333333333333333;
g1_v(4)=(-((1-params(12))*12*params(14)));
g1_v(5)=1;
g1_v(6)=(-1);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 6);
end
end
