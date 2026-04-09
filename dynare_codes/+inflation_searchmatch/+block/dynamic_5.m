function [y, T, residual, g1] = dynamic_5(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(19))-(params(3)*params(2)*y(35)+y(30)*(1-params(3)*params(2)));
  residual(2)=(y(30))-(y(29)+y(18));
  residual(3)=(y(18))-(y(2)*params(3)+(1-params(3))*y(19));
if nargout > 3
    g1_v = NaN(8, 1);
g1_v(1)=(-params(3));
g1_v(2)=(-(1-params(3)*params(2)));
g1_v(3)=1;
g1_v(4)=(-1);
g1_v(5)=1;
g1_v(6)=1;
g1_v(7)=(-(1-params(3)));
g1_v(8)=(-(params(3)*params(2)));
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 9);
end
end
