%% Build system

buildsystem06;

nepochs = 1;

%% Run model

VV = eye(sys.nstatevars);

% Prepare for event handling
options = odeset('Events', @events06, 'AbsTol', 1e-8,'RelTol', 1e-8);

sys.zz = sys.zz0;  % sys.zz0 set in buildsystem

for (ecount = 1:nepochs)    
        % Integrate continuous variables
        fprintf('\nIntegrating vector field...');
        
        [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field06(tt, zz, sys), [0, sys.timecrit], sys.zz, options);
        phi(1:sys.nstatevars, 1:sys.nstatevars) = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
        sys.zz = zzhist(end, :)';
        
        if ~isempty(ie)
            temp = field06(te(end), ze(end, :)', sys);
            fend = temp(1:sys.nstatevars);
            switch ie(end)
                case 1
                    dh = [0, 0, 1, 0, 0, 0, 0, 0];
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
        end;
        
        % For event handling see ode45 > odeset > Event Location Property
        
        % Compute sensitivities
        fprintf('\nComputing sensitivities');
        VV = dg * proj * phi * VV;               
end;

fprintf('\n\n');

