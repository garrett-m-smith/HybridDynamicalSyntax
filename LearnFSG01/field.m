function dz = field11(tt, zz, sys)

dz = zeros(sys.nvars, 1);

% Error:
%dz(sys.index.error) = (1 - zz(sys.index.input))*zz(sys.index.act1)^2 + zz(2)*(1 - zz(3))^2;

% Flow:
dz(sys.index.act1) = zz(sys.index.act1) * (1 - zz(sys.index.act1) - 1.1 * zz(sys.index.act2));
dz(sys.index.act2) = zz(sys.index.act2) * (1 - zz(sys.index.act2) - 1.1 * zz(sys.index.act1));

dz(sys.index.time) = 1;  %  Not what we had before, but seems sensible

dzvarimat = dfield(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);