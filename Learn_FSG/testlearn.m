%% Build system


%%
%% Note:  this model passes the Jacobian test (testjacVV)

buildsystem;

%nepochs = 50;
%nepochs = 100;  % Works if radsquared in events06 is very low (e.g. 0.1)
nepochs = 200;
%nepochs = 400;
%lrate = 10;
%lrate = 0.5;
lrate = 0.05;


%% Initialize

VV = eye(sys.nstatevars); % sensitivity matrix

clear('ehist', 'crittypehist', 'durhist', 'subparamhist');
substatehist = [];
endlist = [];
vvhist = {};

% Prepare for event handling
options = odeset('Events', @events, 'AbsTol', 1e-8,'RelTol', 1e-8); % should use events11, I think

sys.zz = sys.zz0;  % sys.zz0 set in buildsystem

%% Run system and learn
for (ecount = 1:nepochs)    
        % Integrate continuous variables
        %fprintf('\nIntegrating vector field...');
        
        % tt = time, zzhist = solution, te = time of event, ze = solution
        % at time of event, ie = which event criterion was triggered
        [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys), [0, sys.timecrit], sys.zz, options);
        
        % phi holds end state of variational vars, i.e., where
        % perturbations to the initial state ended up
        phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
        sys.zz = zzhist(end, :)';
        
        if ~isempty(ie) % ie = index of successful event fn. evaluation
            temp = field(te(end), ze(end, :)', sys);
            fend = temp(1:sys.nstatevars);
            switch ie(end)
                case 1 % field gets close enough to fixed point
                    %dh = [0, 2*sys.zz(2), 2*sys.zz(3), 0, 0, 0, 0, 0]; % why double these values?
                    dh = [0, 2*sys.zz(2), 2*sys.zz(3), 0, 0]; % why double these values?
                case 2 % time runs out
                    %dh = [0, 0, 0, 0, 0, 0, 0, 1];
                    dh = [0, 0, 0, 0, 1];
            end;
            proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
            dg = feval(@dmap, te(end), ze(end, :)', sys);
            
            % Make discrete state change
            %fprintf('\nMaking discrete state change...');
            sys.zz = feval(@map, te(end), ze(end, :)', sys);
        else % in case event criteria are not met
            proj = eye(sys.nstatevars);
            dg = eye(sys.nstatevars);
            sys.zz = zzhist(end, :)';
        end;
        
        % For event handling see ode45 > odeset > Event Location Property
        
        % Compute sensitivities
        %fprintf('\nComputing sensitivities');
        VV = dg * proj * phi;  
        
        % Store relevant quantities
        ehist(ecount) = sys.zz(1);
        crittypehist(ecount) = ie;
        substatehist{ecount} = zzhist;
        endlist = [endlist; zzhist(end, 2:3)];
        subparamhist(ecount, :) = sys.zz(sys.index.weight);
        durhist(ecount) = te;
        vvhist{ecount} = VV;
        
        % Change weights and reset error and subsystem state
        % only need first row of VV because that contains partial
        % derivatives wrt. the error
        sys.zz(sys.index.weight) = sys.zz(sys.index.weight) + -lrate*VV(1, sys.index.weight)';
        sys.zz(1:3) = sys.zz0(1:3);  % Intialize error to 0 and the state to the original initial state
        sys.zz(8) = 0; % why does this need to be reset to 0?
        sys.zz(sys.index.vari) = reshape(eye(sys.nstatevars), 25, 1);
end;

% Plotting
figure(21);
plot(ehist);
title('Error History');

figure(22);
clf;
hold on;
for (ecount = 1:nepochs)
   plot(substatehist{ecount}(:, 2), substatehist{ecount}(:, 3), 'r-');
   npoints = size(substatehist{ecount}, 1);
   midind = round(npoints/2);
   text(substatehist{ecount}(midind, 2), substatehist{ecount}(midind, 3),...
       num2str(ecount), 'FontSize', 18);
end;
hold on;

% Plot end states of fast dynamics over time
plot(endlist(:, 1), endlist(:, 2), 'bo');
title('Substate histories');

% Plot duration sequence
figure(23);
plot(durhist);
title('Duration Sequence');

%% Plot flow of learned subsystem
% figno = 24;
% %tspan = [0, 2];
% tspan = [0, 0.1];  % Use a pretty short time span so that whole trajectories can be seen in plot
% limits = [-1, 0.1, 1; -1, 0.1, 1];
% plottrajectories(reshape(sys.zz(sys.index.wxx), 2, 2), tspan, limits, figno);


%%

fprintf('\n\n');

