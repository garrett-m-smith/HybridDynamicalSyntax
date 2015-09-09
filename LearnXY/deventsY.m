function dmmat = deventsY(tt, zz, sys)
% Jacobian of eventsY

dmmat = zeros(1, sys.nstatevars);

dmmat(1, sys.index.act) = 1;
dmmat(1, sys.index.eventY) = -1;