function [y, T, residual, g1] = static_6(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(6, 1);
  residual(1)=(y(8))-(params(7)*(y(11)-y(2))+(1-params(7))*y(7));
  residual(2)=(y(2))-(y(2)*params(3)+(1-params(3))*y(3));
  residual(3)=(y(3))-(y(3)*params(3)*params(2)*params(8)+y(9)*(1-params(3)*params(2)*params(8)));
  residual(4)=(y(11))-(y(11)*params(4)+(1-params(4))*y(12));
  residual(5)=(y(12))-(y(12)*params(2)*params(4)+(1-params(2)*params(4))*(y(2)+y(7)+params(1)*y(10)));
  residual(6)=(y(9))-(y(8)+y(2));
if nargout > 3
    g1_v = NaN(14, 1);
g1_v(1)=1;
g1_v(2)=(-1);
g1_v(3)=(-(1-params(3)));
g1_v(4)=1-params(3)*params(2)*params(8);
g1_v(5)=(-(1-params(3)*params(2)*params(8)));
g1_v(6)=1;
g1_v(7)=(-params(7));
g1_v(8)=1-params(4);
g1_v(9)=(-(1-params(4)));
g1_v(10)=1-params(2)*params(4);
g1_v(11)=params(7);
g1_v(12)=1-params(3);
g1_v(13)=(-(1-params(2)*params(4)));
g1_v(14)=(-1);
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 6, 6);
end
end
