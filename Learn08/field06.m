function dz = field06(tt, zz, sys)

dz = zeros(sys.nvars, 1);


dz(1) = zz(2)^2 + zz(3)^2;

dz(2:3) = [zz(4), zz(6);
           zz(5), zz(7)] * zz(2:3);

dzvarimat = dfield06(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);