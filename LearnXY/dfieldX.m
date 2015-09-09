function dfmat = dfieldX(tt, zz, sys)
% Jacobian of fieldX

dfmat = zeros(sys.nstatevars, sys.nstatevars);

dfmat(sys.index.error, sys.index.act) = 2 * zz(sys.index.act) - (2 * zz(sys.index.interceptX)) / (zz(sys.index.slopeX));
dfmat(sys.index.error, sys.index.interceptX) = (-2 * zz(sys.index.act)) / (zz(sys.index.slopeX)) + 2 * (zz(sys.index.interceptX)) / (zz(sys.index.slopeX));
dfmat(sys.index.error, sys.index.slopeX) = (2 * zz(sys.index.act) * zz(sys.index.interceptX)) / (zz(sys.index.slopeX)^2) - (2 * zz(sys.index.interceptX)^2) / (zz(sys.index.slopeX)^3);

dfmat(sys.index.act, sys.index.slopeX) = zz(sys.index.act);
dfmat(sys.index.act, sys.index.act) = zz(sys.index.slopeX);
dfmat(sys.index.act, sys.index.interceptX) = 1;