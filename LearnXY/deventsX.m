function dmmat = deventsX(tt, zz, sys)
% Jacobian of eventsX

dmmat = zeros(1, sys.nstatevars);

dmmat(1, sys.index.act) = 1;
dmmat(1, sys.index.eventX) = -1;