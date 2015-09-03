function dfmat = dfield11(tt, zz, sys)

% DFIELD (partial derivatives of field functions with respect to field
% variables)
% Double checked: seem ok

dfmat = zeros(sys.nstatevars,sys.nstatevars);

dfmat(sys.index.error, sys.index.act1) = 2 * zz(sys.index.act1);
dfmat(sys.index.error, sys.index.act2) = -2 + 2 * zz(sys.index.act2);
dfmat(sys.index.act1, sys.index.act1) = 1 - 2 * zz(sys.index.act1) - 1.1 * zz(sys.index.act2);
dfmat(sys.index.act1, sys.index.act2) = -1.1 * zz(sys.index.act1);
dfmat(sys.index.act2, sys.index.act1) = -1.1 * zz(sys.index.act2);
dfmat(sys.index.act2, sys.index.act2) = 1 - 2 * zz(sys.index.act2) - 1.1 * zz(sys.index.act1);