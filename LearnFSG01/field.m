function dz = field(tt, zz, sys)

dz = zeros(sys.nvars, 1);

% Error:
%dz(sys.index.error) = (1 - zz(sys.index.input))*zz(sys.index.act1)^2 + zz(2)*(1 - zz(3))^2;
% Sum of squares from fp at (1, 0):
dz(sys.index.error) = (0 - zz(sys.index.act1))^2 + (1 - zz(sys.index.act2))^2;

% Flow:
dz(sys.index.act1) = zz(sys.index.act1) * (zz(sys.index.input) - 1 * zz(sys.index.act1) - 2 * zz(sys.index.act2));
% dz(sys.index.act1) = zz(sys.index.act1) * (1 - 3 * zz(sys.index.act1) - 2 * zz(sys.index.act2));
dz(sys.index.act2) = zz(sys.index.act2) * (1 - 1 * zz(sys.index.act2) - 2 * zz(sys.index.act1));

dz(sys.index.time) = 1;  %  Not what we had before, but seems sensible

% dzvarimat = dfield(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);
dzvarimat = eye(sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);