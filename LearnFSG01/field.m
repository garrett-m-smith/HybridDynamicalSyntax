function dz = field(tt, zz, sys)

% Parameters:
% Inputs = ibit (3 dim); set up map from input to param vector. 
% For now: input = vector of with values of params;

gr1 = zz(sys.index.input(1)); % exponential growth param for act1
gr2 = zz(sys.index.input(2)); % growth param for act2
intra = zz(sys.index.input(3)); % intra-specific competition param


dz = zeros(sys.nvars, 1);

% Error:
%dz(sys.index.error) = (1 - zz(sys.index.input))*zz(sys.index.act1)^2 + zz(2)*(1 - zz(3))^2;
% Sum of squares from fp at (1, 0): doesn't work for other fixed points
dz(sys.index.error) = (0 - zz(sys.index.act1))^2 + (1 - zz(sys.index.act2))^2;
% Try velocity
% Product of dist to all fixed points: goes to zero when near one fp

% Flow:
dz(sys.index.act1) = zz(sys.index.act1) * (gr1 - intra * zz(sys.index.act1) - 2 * zz(sys.index.act2));
dz(sys.index.act2) = zz(sys.index.act2) * (gr2 - intra * zz(sys.index.act2) - 2 * zz(sys.index.act1));

dz(sys.index.time) = 1;  %  Not what we had before, but seems sensible

dzvarimat = dfield(tt, zz, sys) * reshape(zz(sys.index.vari), sys.nstatevars, sys.nstatevars);
% dzvarimat = eye(sys.nstatevars);

dz(sys.index.vari) = reshape(dzvarimat, sys.nstatevars^2, 1);