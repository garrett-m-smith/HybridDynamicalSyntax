function dmmat = dmap11(tt, zz, sys)

% DMAP (partial derivatives of discrete map functions with 
% respect to discrete map variables)

dmmat = eye(sys.nstatevars);

%dmmat(sys.index.act, sys.index.act) = 0;


