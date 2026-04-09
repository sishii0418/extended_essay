function [y, T] = static_5(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(6)=y(3)*1/params(4)+y(4)*1/params(5);
  y(7)=params(1)*y(9)+y(6);
end
