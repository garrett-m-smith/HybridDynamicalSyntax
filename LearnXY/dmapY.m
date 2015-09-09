function dmmat = dmapY(tt, zz, sys)
% Jacobian of mapY

dmmat = eye(sys.nstatevars);

dmmat(sys.index.act, sys.index.mapY) = zz(sys.index.act);
dmmat(sys.index.act, sys.index.act) = zz(sys.index.mapY);