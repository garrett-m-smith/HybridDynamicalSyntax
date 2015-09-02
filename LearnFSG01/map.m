function gg = map11(tt, zz, sys)
% jump state back to 0.5
gg = zz;

% Check the location of the saddle pt.
gg(sys.index.act1) = 0.5;
gg(sys.index.act2) = 0.5;

