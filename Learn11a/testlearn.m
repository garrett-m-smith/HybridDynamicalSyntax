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
    tstart = 0;
    % Integrate continuous variables
    fprintf('\nIntegrating vector field...');
    
    % tt = time, zzhist = solution, te = time of event, ze = solution
    % at time of event, ie = which event criterion was triggered
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys), [0, sys.timecrit], sys.zz, options);
    
    % phi holds end state of variational vars, i.e., where
    % perturbations to the initial state ended up
    phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
    sys.zz = zzhist(end, :)';
    
    if ~isempty(ie) % ie = index of successful event fn. evaluation
        temp = field(te(end), ze(end, :)', sys);
        %         fend = temp(1:sys.nstatevars);
        f1 = temp(1:sys.nstatevars); % run field from where event happened
        switch ie(end)
            case 1 % field gets close enough to fixed point
                %dh = [0, 2*sys.zz(2), 2*sys.zz(3), 0, 0, 0, 0, 0]; % why double these values?
                dh = [0, 0, -2*sys.zz(3) + 1, 0, 0]; % why double these values?
                dg = feval(@dmap, te(end), ze(end, :)', sys);
                sys.zz = feval(@map, te(end), ze(end,:)', sys);
            case 2 % time runs out
                dh = [0, 0, 0, 0, 1];
                dg = eye(sys.nstatevars);
        end
        temp = field(te(end), sys.zz', sys);
        f2 = temp(1:sys.nstatevars);
        %         proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
        %         dg = feval(@dmap, te(end), ze(end, :)', sys);
        
        % Make discrete state change
        fprintf('\nMaking discrete state change...');
        %         sys.zz = feval(@map, te(end), ze(end, :)', sys);
        % Sometimes Matlab gets hung up after event; this prevents that:
        sys.zz(1:sys.nstatevars) = sys.zz(1:sys.nstatevars) + f2 * 1e-10;
        VV = (dg + ((f2 - dg * f1) * dh)/(dh * f1)) * phi;
        sys.zz(sys.index.vari) = VV(:);
    end;
    
    % For event handling see ode45 > odeset > Event Location Property
    
    % Compute sensitivities
    %fprintf('\nComputing sensitivities');
    %     VV = dg * proj * phi;
    
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
    
%     sys.zz(1:3) = sys.zz0(1:3);  % Intialize error to 0 and the state to the original initial state
    sys.zz(sys.index.error) = sys.zz0(sys.index.error);
    sys.zz(sys.index.input) = binornd(1, 0.5); % randomly choose 0 or 1 to det dyn. of field
    sys.zz(sys.index.act) = sys.zz0(sys.index.act);
    sys.zz(sys.index.time) = 0;
    sys.zz(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
end;

%% Plotting
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

% Plot weight history
figure(24);
plot(subparamhist);
title('Weight hsitory');

%% Plot flow of learned subsystem
% figno = 24;
% %tspan = [0, 2];
% tspan = [0, 0.1];  % Use a pretty short time span so that whole trajectories can be seen in plot
% limits = [-1, 0.1, 1; -1, 0.1, 1];
% plottrajectories(sys.zz(sys.index.weight), tspan, limits, figno);

%%

fprintf('\n\n');

