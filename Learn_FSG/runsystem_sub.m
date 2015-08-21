function sysout = runsystem_sub(sys)

%% runsystem

% This version is for testing:  it assumes system has already been built
% and that the initial state has already been set

% %% Build system
%
% buildsystem;
%
% nepochs = 1;

%% Initialize

% Prepare for event handling
options = odeset('Events', @events, 'AbsTol', 1e-8,'RelTol', 1e-8);

sys.zz = sys.zz0;  % sys.zz0 set in controlling program
%zzstart11pre = sys.zz0;


%% Run system until criterion is met
% Integrate continuous variables
fprintf('\nIntegrating vector field...');

tstart = 0;

while tstart < sys.timecrit
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys), [tstart, sys.timecrit], sys.zz, options);
    
    tstart = tt(end);
    phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
    sys.zz = zzhist(end, :)';
    
    if ~isempty(ie)
        temp = field(te(end), ze(end, :)', sys);
        fend = temp(1:sys.nstatevars);
        switch ie(end)
            case 1
                dh = [0, 0, -2*sys.zz(3) + 1, 0, 0];
                %dh = [0, 0, 2*sys.zz(3), 0, 0];  % A simple case, for testing
            case 2
                dh = [0, 0, 0, 0, 1];
        end;
        proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
        dg = feval(@dmap, te(end), ze(end, :)', sys);
        
        % Make discrete state change
        fprintf('\nMaking discrete state change...');
        sys.zz = feval(@map, te(end), ze(end, :)', sys);
        sys.zz(1:sys.nstatevars) = sys.zz(1:sys.nstatevars) + fend * 1e-10;
        VV = dg * proj * phi;
        sys.zz(sys.index.vari) = VV(:);
    end;
end;

tstart
sysout = sys;
fprintf('\n\n');
