% Set initial parameter values

sys.statecrit = 0;
sys.timecrit = 100;  % Not sure what the best idea is here
%sys.timecrit = 0.8;
%sys.timecrit = 0.5;
sys.weight0 = 0;  % Weight parameter
%sys.weight0 = 0.1; % For testing
sys.act0 = 0.5; % Activation parameter
%sys.act0 = 0.4; % For testing


% Defining indexes
   
sys.index.error = 1;
sys.index.input = 2; % 0 or 1
sys.index.act = 3;
sys.index.weight = 4;
sys.index.time = 5;

sys.index.vari = 6:30; % variational variables

sys.nvars = sys.index.vari(end);
sys.nstatevars = sys.index.vari(1)-1;

% Set the initial state

sys.zz0 = zeros(sys.nvars, 1); % zz stores all variables, including variational vars
% Initialize state variables:
sys.zz0(1:sys.nstatevars) = [0; 0; sys.act0; sys.weight0; 0];  % Error, Input, Activation, Weight, Time
% Initialize variational variables:
sys.zz0(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
