% Set initial parameter values

% sys.statecrit = 0;
sys.timecrit = 150;  % Not sure what the best idea is here
% sys.weight0 = 0.00;  % Weight parameter;
sys.act1_0 = 0.25; % Initial activation
sys.act2_0 = 0.25; % Initial activation
sys.input0 = [-1, -1]; % gr1, gr2; X
% sys.input0 = [1, 0.1]; % Y
% sys.input0 = [0.1, 1]; % Z
% sys.input0 = [0, 0, 0];
% sys.intra_0 = 1;


% Defining indexes
sys.index.error = 1;
sys.index.input = 2:3; % 0 or 1
sys.index.act1 = 4;
sys.index.act2 = 5;
sys.index.time = 6;
% sys.index.gr1 = 5;
% sys.index.gr2 = 6;
% sys.index.intra = 7;
% sys.index.time = 8;

sys.nstatevars = 6;
sys.nvars = sys.nstatevars^2 + sys.nstatevars;
sys.index.vari = (sys.nstatevars + 1):sys.nvars; % variational variables

% Set the initial state

sys.zz0 = zeros(sys.nvars, 1); % zz stores all variables, including variational vars
% Initialize state variables:
sys.zz0(1:sys.nstatevars) = [0, sys.input0, sys.act1_0, sys.act2_0, 0]';
% Initialize variational variables:
sys.zz0(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
