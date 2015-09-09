function dfmat = dfieldY(tt, zz, sys)
% Jacobian of fieldY

dfmat = zeros(sys.nstatevars, sys.nstatevars);

dfmat(sys.index.error, sys.index.act) = 2 * zz(sys.index.act) - (2 * zz(sys.index.interceptY)) / (zz(sys.index.slopeY));
dfmat(sys.index.error, sys.index.interceptY) = (-2 * zz(sys.index.act)) / (zz(sys.index.slopeY)) + 2 * (zz(sys.index.interceptY)) / (zz(sys.index.slopeY));
dfmat(sys.index.error, sys.index.slopeY) = (2 * zz(sys.index.act) * zz(sys.index.interceptY)) / (zz(sys.index.slopeY)^2) - (2 * zz(sys.index.interceptY)^2) / (zz(sys.index.slopeY)^3);

dfmat(sys.index.act, sys.index.slopeY) = zz(sys.index.act);
dfmat(sys.index.act, sys.index.act) = zz(sys.index.slopeY);
dfmat(sys.index.act, sys.index.interceptY) = 1;