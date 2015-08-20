function gg = map06(tt, zz, sys)

gg = zz;

gg(sys.index.xx) = sys.jumpsize*zz(sys.index.xx);

