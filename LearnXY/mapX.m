function gg = mapX(tt, zz, sys)
% Jump function after settling to X fixed point
gg = zz;

gg(sys.index.act) = zz(sys.index.mapX) * zz(sys.index.act);