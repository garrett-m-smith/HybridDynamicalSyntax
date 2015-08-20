function [VV, finalstate, phi] = runsystem06sub(sys)

%% runsystem

% This version is for testing:  it assumes system has already been built
% and that the initial state has already been set

% %% Build system
% 
% buildsystem06;
% 
% nepochs = 1;

%% Initialize

VV0 = eye(sys.nstatevars);
VV = VV0;

% Prepare for event handling
zzstart06preoptions = sys.zz0;
options = odeset('Events', @events06, 'AbsTol', 1e-8,'RelTol', 1e-8);

sys.zz = sys.zz0;  % sys.zz0 set in controlling program
zzstart06pre = sys.zz0;


%% Run system until criterion is met
% Integrate continuous variables
fprintf('\nIntegrating vector field...');

[tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field06(tt, zz, sys), [0, sys.timecrit], sys.zz, options);
zzstart06 = sys.zz;
phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
sys.zz = zzhist(end, :)';

if ~isempty(ie)
    temp = field06(te(end), ze(end, :)', sys);
    fend = temp(1:sys.nstatevars);
    switch ie(end)
        case 1
            dh = [0, 2*sys.zz(2), 2*sys.zz(3), 0, 0, 0, 0, 0];
            %dh = [0, 0, 1, 0, 0, 0, 0, 0];
        case 2
            dh = [0, 0, 0, 0, 0, 0, 0, 1];
    end;
    proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
    dg = feval(@dmap06, te(end), ze(end, :)', sys);
    
    % Make discrete state change
    fprintf('\nMaking discrete state change...');
    sys.zz = feval(@map06, te(end), ze(end, :)', sys);
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
