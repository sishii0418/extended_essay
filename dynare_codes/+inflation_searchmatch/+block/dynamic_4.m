function [y, T, residual, g1] = dynamic_4(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  y(24)=y(23)+y(25);
  residual(1)=(y(23))-((-(params(6)*params(7)/params(8)))*y(6));
  residual(2)=(y(22))-(params(6)*y(6)+(1-params(6))*(y(24)+y(26)));
if nargout > 3
    g1_v = NaN(3, 1);
g1_v(1)=1;
g1_v(2)=(-(1-params(6)));
g1_v(3)=1;
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 2);
end
end
