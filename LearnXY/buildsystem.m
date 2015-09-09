%% LearnXY
% Goal: system should jump toward the predicted next symbol, get input,
% according to the dynamics determined by the input until a stopping
% criterion is met, then jump to next prediction. Input is a two-state
% Markov process with P(X->Y) > P(X->X) and P(Y->X) > P(Y->Y).

%% Set initial parameter values

% sys.statecrit = 0;
sys.timecrit = 40;
sys.act0 = 0.5; % Initial activation

%% Defining indexes
sys.index.error = 1;
sys.index.input = 2; % 0 or 1
sys.index.act = 3;
sys.index.slopeX = 4;
sys.index.interceptX = 5;
sys.index.slopeY = 6;
sys.index.interceptY = 7;
sys.index.mapX = 8;
sys.index.mapY = 9;
sys.index.eventX = 10;
sys.index.eventY = 11;
sys.index.time = 12;

sys.nstatevars = 12;
sys.nvars = sys.nstatevars + sys.nstatevars^2;
sys.index.state = 1:sys.nstatevars;
sys.index.vari = (sys.index.time + 1):sys.nvars; % variational variables

%% Set the initial state
sys.zz0 = zeros(sys.nvars, 1); % zz stores all variables, including variational vars
% Initialize state variables:
% sys.zz0 = [0; 0; sys.act0; sys.weight0; 0];
sys.zz0(1:sys.nstatevars) = zeros(sys.nstatevars, 1);
% Initialize variational variables:
sys.zz0(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
