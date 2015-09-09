function dz = fieldY(tt, zz, sys)
% Field equation for settling to Y

dz = zeros(sys.nvars, 1);

% Error: squared dist to fixed point for Y flow
dz(sys.index.error) = (zz(sys.index.act) - zz(sys.index.interceptY)/zz(sys.index.slopeY))^2;

% For simplicity, simple affine fn.
dz(sys.index.act) = zz(sys.index.slopeY) * zz(sys.index.act) + zz(sys.index.interceptY);

dz(sys.index.time) = 1;

dzvarimat = dfieldY(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);