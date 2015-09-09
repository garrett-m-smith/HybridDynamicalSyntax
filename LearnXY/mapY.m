function gg = mapY(tt, zz, sys)
% Jump function for after settling to Y fixed point
gg = zz;

gg(sys.index.act) = zz(sys.index.mapY) * zz(sys.index.act);