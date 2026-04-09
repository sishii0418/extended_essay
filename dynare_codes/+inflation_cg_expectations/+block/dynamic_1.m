function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(21)=params(9)*y(10)+x(1);
  y(22)=params(10)*y(11)+y(21)*params(11);
end
