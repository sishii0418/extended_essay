function [y, T] = static_1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(1)=0;
  y(11)=x(1);
  y(12)=y(11);
end
