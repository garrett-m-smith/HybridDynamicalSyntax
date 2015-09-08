function dfmat = dfield(tt, zz, sys)

% DFIELD (partial derivatives of field functions with respect to field
% variables)

gr1 = zz(sys.index.input(1)); % exponential growth param for act1
gr2 = zz(sys.index.input(2)); % growth param for act2

dfmat = zeros(sys.nstatevars,sys.nstatevars);

dfmat(sys.index.error, sys.index.act1) = 6 * zz(sys.index.act1) - 2;
dfmat(sys.index.error, sys.index.act2) = 6 * zz(sys.index.act2) - 2;
dfmat(sys.index.act1, sys.index.input(1)) = -zz(sys.index.act1);
dfmat(sys.index.act1, sys.index.act1) = 1 - gr1 - 2 * zz(sys.index.act1) - 2 * zz(sys.index.act2);
dfmat(sys.index.act1, sys.index.act2) = -2 * zz(sys.index.act1);
dfmat(sys.index.act2, sys.index.input(2)) = -zz(sys.index.act2);
dfmat(sys.index.act2, sys.index.act1) = -2 * zz(sys.index.act2);
dfmat(sys.index.act2, sys.index.act2) = 1 - gr2 - 2 * zz(sys.index.act2) - 2 * zz(sys.index.act2);