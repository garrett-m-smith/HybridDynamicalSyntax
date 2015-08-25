function gg = map11(tt, zz, sys)
% jump state back to 0.5
gg = zz;

gg(sys.index.act) = 0.5;

