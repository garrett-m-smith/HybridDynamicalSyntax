function gg = map11(tt, zz, sys)
% jump state to near the saddle pt.
gg = zz;

% Check the location of the saddle pt.
gg(sys.index.act1) = 0.25;
% gg(sys.index.act2) = 0.25 + sys.zz(sys.index.input);
gg(sys.index.act2) = 0.26;

