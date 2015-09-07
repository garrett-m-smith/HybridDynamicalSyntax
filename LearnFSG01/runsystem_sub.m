function sysout = runsystem_sub(sys_in)

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

sys_in.zz = sys_in.zz0;  % sys.zz0 set in controlling program
%zzstart11pre = sys.zz0;


%% Run system until criterion is met
% Integrate continuous variables
tstart = 0;

while tstart < sys_in.timecrit
    fprintf('\nIntegrating vector field...');
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys_in), [tstart, sys_in.timecrit], sys_in.zz, options);
    
    tstart = tt(end);
    % value of variational variables after the flow
    phi = reshape(zzhist(end, sys_in.index.vari), sys_in.nstatevars, sys_in.nstatevars); 
    sys_in.zz = zzhist(end, :)';
    
    if ~isempty(ie)
        temp = field(te(end), ze(end, :)', sys_in);
        f1 = temp(1:sys_in.nstatevars); % value of field right at the error surface
        switch ie(end)
            case 1
                % deriv of event fn.:
                dh = [0, 0, sys_in.zz(sys_in.index.act1) / sqrt(sys_in.zz(sys_in.index.act1)^2 + ...
                    1 - 2 * sys_in.zz(sys_in.index.act2) + sys_in.zz(sys_in.index.act2)^2), ...
                    0.5 * (-2 + 2 * sys_in.zz(sys_in.index.act2)) / sqrt(sys_in.zz(sys_in.index.act1)^2 + ...
                    1 - 2 * sys_in.zz(sys_in.index.act2) + sys_in.zz(sys_in.index.act2)^2), 0];
                dg = feval(@dmap, te(end), ze(end, :)', sys_in); % deriv of map
                sys_in.zz = feval(@map, te(end), ze(end, :)', sys_in); % make the jump
            case 2
                dh = [0, 0, 0, 0, 1];
                dg = eye(sys_in.nstatevars);
        end
        temp = field(te(end), sys_in.zz', sys_in);
        f2 = temp(1:sys_in.nstatevars); % value of field continuing right after jump
        % Make discrete state change
        fprintf('\nMaking discrete state change...');
        sys_in.zz(1:sys_in.nstatevars) = sys_in.zz(1:sys_in.nstatevars) + f2 * 1e-10;
        VV = (dg + ((f2 - dg * f1) * dh)/(dh * f1)) * phi;
        sys_in.zz(sys_in.index.vari) = VV(:);
    end;
end;

%tstart
sysout = sys_in;
fprintf('\n\n');
