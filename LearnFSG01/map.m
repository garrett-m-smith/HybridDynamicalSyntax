function gg = map(tt, zz, sys)
% jump state to near the saddle pt.
gg = zz;

% Check the location of the saddle pt.
% gg(sys.index.act1) = 0.5; %+ sys.zz(sys.index.input);
% gg(sys.index.act2) = 0.5;
gg(sys.index.act1) = (1 - zz(sys.index.act1)) * (1 - zz(sys.index.act2)) + 0.05;
gg(sys.index.act2) = (1 - zz(sys.index.act1)) * (1 - zz(sys.index.act2)) + 0.05;