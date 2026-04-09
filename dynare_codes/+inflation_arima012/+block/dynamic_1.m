function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(23)=x(1);
  y(24)=y(11);
  y(22)=x(1)+y(10)+y(11)*params(9)+params(10)*y(12);
end
