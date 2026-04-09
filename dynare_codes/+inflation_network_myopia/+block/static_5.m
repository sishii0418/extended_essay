function [y, T] = static_5(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(7)=y(4)*1/params(7)+y(5)*1/params(8);
end
