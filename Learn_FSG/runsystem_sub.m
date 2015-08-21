function [VV, finalstate, phi] = runsystem_sub(sys)

%% runsystem

% This version is for testing:  it assumes system has already been built
% and that the initial state has already been set

% %% Build system
% 
% buildsystem;
% 
% nepochs = 1;

%% Initialize

VV0 = eye(sys.nstatevars);
VV = VV0;

% Prepare for event handling
options = odeset('Events', @events, 'AbsTol', 1e-8,'RelTol', 1e-8);

sys.zz = sys.zz0;  % sys.zz0 set in controlling program
%zzstart11pre = sys.zz0;


%% Run system until criterion is met
% Integrate continuous variables
fprintf('\nIntegrating vector field...');

[tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys), [0, sys.timecrit], sys.zz, options);

phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
sys.zz = zzhist(end, :)';

if ~isempty(ie)
    temp = field(te(end), ze(end, :)', sys);
    fend = temp(1:sys.nstatevars);
    switch ie(end)
        case 1
            dh = [0, -2*sys.zz(3) + 1, 2*sys.zz(3) - 2*sys.zz(2), 0, 0];
            %dh = [0, 0, 2*sys.zz(3), 0, 0];  % A simple case, for testing
        case 2
            dh = [0, 0, 0, 0, 1];
    end;
    proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
    dg = feval(@dmap, te(end), ze(end, :)', sys);
    
    % Make discrete state change
    fprintf('\nMaking discrete state change...');
    sys.zz = feval(@map, te(end), ze(end, :)', sys);
else
    proj = eye(sys.nstatevars);
    dg = eye(sys.nstatevars);
    sys.zz = zzhist(end, :)';
end;

% For event handling see ode45 > odeset > Event Location Property

% Compute sensitivities
fprintf('\nComputing sensitivities');
VV = dg * proj * phi * VV;

finalstate = sys.zz;

fprintf('\n\n');
