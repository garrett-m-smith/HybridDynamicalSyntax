function dmmat = dmap06(tt, zz, sys)

% DMAP (partial derivatives of discrete map functions with 
% respect to discrete map variables)

dmmat = eye(sys.nstatevars);

dmmat(sys.index.xx(1), sys.index.xx(1)) = sys.jumpsize;
dmmat(sys.index.xx(2), sys.index.xx(2)) = sys.jumpsize;

