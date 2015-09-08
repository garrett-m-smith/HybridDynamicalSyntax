function dmmat = dmap(tt, zz, sys)

% DMAP (partial derivatives of discrete map functions with 
% respect to discrete map variables)

dmmat = eye(sys.nstatevars);
dmmat(sys.index.act1, sys.index.act1) = -1 + zz(sys.index.act2);
dmmat(sys.index.act1, sys.index.act2) = -1 + zz(sys.index.act1);
dmmat(sys.index.act2, sys.index.act1) = -1 + zz(sys.index.act2);
dmmat(sys.index.act2, sys.index.act1) = -1 + zz(sys.index.act1);