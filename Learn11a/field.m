function dz = field11(tt, zz, sys)

dz = zeros(sys.nvars, 1);

% Error:
dz(1) = (1 - zz(2))*zz(3)^2 + zz(2)*(1 - zz(3))^2;
%dz(1) = zz(3)^2;  % A simple case, for testing

% Flow: normal form of transcrit. bif., but use concavity of parabola to
% select stability of the two fixed points instead of ctl. parameter
% zz(4) is the weight determining how fast the state approaches the stable
% fixed point, which is set by the fourth term in the equation
dz(3) = zz(3)*(1 - zz(3))*zz(4)*(2*zz(2) - 1);
%dz(3) = zz(3)*(1 - zz(3));

dz(5) = 1;  %  Not what we had before, but seems sensible

dzvarimat = dfield(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);