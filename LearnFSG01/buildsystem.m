% Set initial parameter values

sys.statecrit = 0;
sys.timecrit = 40;  % Not sure what the best idea is here
sys.weight0 = 0.00;  % Weight parameter;
sys.act1_0 = 0.1; % Initial activation
sys.act2_0 = 0.1; % Initial activation
sys.param0 = 1;


% Defining indexes
sys.index.error = 1;
sys.index.input = 2; % 0 or 1
sys.index.act1 = 3;
sys.index.act2 = 4;
% sys.index.param = 5;
sys.index.time = 5;

sys.nstatevars = 5;
sys.nvars = sys.nstatevars^2 + sys.nstatevars;
sys.index.vari = (sys.nstatevars + 1):sys.nvars; % variational variables

% Set the initial state

sys.zz0 = zeros(sys.nvars, 1); % zz stores all variables, including variational vars
% Initialize state variables:
% sys.zz0(1:sys.nstatevars) = [0; 0; sys.act1_0; sys.act2_0; sys.param0; 0];  % Error, Input, Activations, stability param, Time
sys.zz0(1:sys.nstatevars) = [0; 0.01; sys.act1_0; sys.act2_0; 0];
% Initialize variational variables:
sys.zz0(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
