function dz = fieldX(tt, zz, sys)
% Field equation for settling to X

dz = zeros(sys.nvars, 1);

% Error: squared dist to fixed point for X flow
dz(sys.index.error) = (zz(sys.index.act) - zz(sys.index.interceptX)/zz(sys.index.slopeX))^2;

% For simplicity, simple affine fn.
dz(sys.index.act) = zz(sys.index.slopeX) * zz(sys.index.act) + zz(sys.index.interceptX);

dz(sys.index.time) = 1;

dzvarimat = dfieldX(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);