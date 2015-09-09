function sysout = runsystem_sub(sys_in)
%% runsystem
% This version is for testing:  it assumes system has already been built
% and that the initial state has already been set

%% Initialize
sys_in.zz = sys_in.zz0;  % sys.zz0 set in controlling program
%zzstart11pre = sys.zz0;


%% Run system until criterion is met
tstart = 0;

while tstart < sys_in.timecrit
%     assert(sys_in.zz(sys_in.index.input) == 0 | sys_in.zz(sys_in.index.input) == 1, 'Input not 0 or 1\n');
    
    switch sys_in.zz(sys_in.index.input)
        case 0 % X in the input
            % Prepare for event handling
            options = odeset('Events', @(tt, zz) eventsX(tt, zz, sys_in), 'AbsTol', 1e-8,'RelTol', 1e-8);
            fprintf('\nIntegrating vector field...');
            [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) fieldX(tt, zz, sys_in), [tstart, sys_in.timecrit], sys_in.zz, options);
            tstart = tt(end);
            
            % value of variational variables after the flow
            phi = reshape(zzhist(end, sys_in.index.vari), sys_in.nstatevars, sys_in.nstatevars);
            sys_in.zz = zzhist(end, :)';
            
            if ~isempty(ie)
                temp = fieldX(te(end), ze(end, :)', sys_in);
                f1 = temp(1:sys_in.nstatevars); % value of field right at the error surface
                switch ie(end)
                    case 1
                        dh = [0, 0, -2*sys_in.zz(3) + 1, 0, 0]; % deriv of error fn.
                        dg = feval(@dmapX, te(end), ze(end, :)', sys_in); % deriv of map
                        fprintf('Making discrete state change...\n');
                        sys_in.zz = feval(@mapX, te(end), ze(end, :)', sys_in); % make the jump to location predicted after X
                    case 2
                        fprintf('Timed out in event function.\n');
                        dh = [0, 0, 0, 0, 1];
                        dg = eye(sys_in.nstatevars);
                end
                temp = fieldX(te(end), sys_in.zz', sys_in);
                f2 = temp(1:sys_in.nstatevars); % value of field continuing right after jump
                sys_in.zz(1:sys_in.nstatevars) = sys_in.zz(1:sys_in.nstatevars) + f2 * 1e-10;
                % Updating sensitivities
                VV = (dg + ((f2 - dg * f1) * dh)/(dh * f1)) * phi;
                sys_in.zz(sys_in.index.vari) = VV(:);
            end;
        case 1 % Y in input
            options = odeset('Events', @(tt, zz) eventsY(tt, zz, sys_in), 'AbsTol', 1e-8,'RelTol', 1e-8);
            fprintf('\nIntegrating vector field...');
            [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) fieldY(tt, zz, sys_in), [tstart, sys_in.timecrit], sys_in.zz, options);
            
            tstart = tt(end);
            % value of variational variables after the flow
            phi = reshape(zzhist(end, sys_in.index.vari), sys_in.nstatevars, sys_in.nstatevars);
            sys_in.zz = zzhist(end, :)';
            
            if ~isempty(ie)
                temp = fieldY(te(end), ze(end, :)', sys_in);
                f1 = temp(1:sys_in.nstatevars); % value of field right at the error surface
                switch ie(end)
                    case 1
                        dh = [0, 0, -2*sys_in.zz(3) + 1, 0, 0]; % deriv of error fn.
                        dg = feval(@dmapY, te(end), ze(end, :)', sys_in); % deriv of map
                        fprintf('\nMaking discrete state change...');
                        sys_in.zz = feval(@mapY, te(end), ze(end, :)', sys_in); % make the jump to location predicted after Y
                    case 2
                        fprintf('Timed out in event function.\n');
                        dh = [0, 0, 0, 0, 1];
                        dg = eye(sys_in.nstatevars);
                end
                temp = fieldY(te(end), sys_in.zz', sys_in);
                f2 = temp(1:sys_in.nstatevars); % value of field continuing right after jump
                sys_in.zz(1:sys_in.nstatevars) = sys_in.zz(1:sys_in.nstatevars) + f2 * 1e-10;
                VV = (dg + ((f2 - dg * f1) * dh)/(dh * f1)) * phi;
                sys_in.zz(sys_in.index.vari) = VV(:);
            end;
    end;
end;

sysout = sys_in;
fprintf('\n\n');