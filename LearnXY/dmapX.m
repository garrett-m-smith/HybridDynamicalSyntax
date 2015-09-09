function dmmat = dmapX(tt, zz, sys)
% Jacobian of mapX

dmmat = eye(sys.nstatevars);

dmmat(sys.index.act, sys.index.mapX) = zz(sys.index.act);
dmmat(sys.index.act, sys.index.act) = zz(sys.index.mapX);