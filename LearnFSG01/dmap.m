function dmmat = dmap(tt, zz, sys)

% DMAP (partial derivatives of discrete map functions with 
% respect to discrete map variables)

dmmat = eye(sys.nstatevars);
%dmmat = zeros(sys.nstatevars, sys.nstatevars);

dmmat(sys.index.act1, sys.index.act1) = 0;
dmmat(sys.index.act2, sys.index.act2) = 0;