function [y, T] = static_6(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(7)=y(4)*1/params(4)+y(5)*1/params(5);
  y(8)=params(1)*y(10)+y(7);
end
