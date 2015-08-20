%% Build system

%% This version does sort of OK in that the error overall decreases.
%% The error, however, makes a slight upturn from steps 5 to 6.
%% For some reason, it makes a huge decrease in duration from steps 6
%% to 7 and this results in a corresponding big decrease in the error 
%% (bringing it close to 0).  The shift from step 6 to 7 involves a large
%% shift in the magnitudes of the subparams.  Despite this large shift,
%% the eigenvalues only change slightly, and indeed, while the second eigenvalue
%% stays nearly constant, the first decreases slightly over the course
%% of steps 1 through 7.  By step 8, the weights are humongous and eig(1) =
%% -eig(2).
%%
%% Note:  this model passes the Jacobian test (testjacVV)

buildsystem06;

%nepochs = 50;
%nepochs = 100;  % Works if radsquared in events06 is very low (e.g. 0.1)
nepochs = 200;
%nepochs = 400;
%lrate = 10;
lrate = 0.5;


%% Initialize

VV = eye(sys.nstatevars);

clear('ehist', 'crittypehist', 'durhist', 'subparamhist');
substatehist = [];
endlist = [];
vvhist = {};

% Prepare for event handling
options = odeset('Events', @events06, 'AbsTol', 1e-8,'RelTol', 1e-8);

sys.zz = sys.zz0;  % sys.zz0 set in buildsystem

for (ecount = 1:nepochs)    
        % Integrate continuous variables
        %fprintf('\nIntegrating vector field...');
        
        [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field06(tt, zz, sys), [0, sys.timecrit], sys.zz, options);
        phi = reshape(zzhist(end, sys.index.vari), sys.nstatevars, sys.nstatevars);
        sys.zz = zzhist(end, :)';
        
        if ~isempty(ie)
            temp = field06(te(end), ze(end, :)', sys);
            fend = temp(1:sys.nstatevars);
            switch ie(end)
                case 1
                    dh = [0, 2*sys.zz(2), 2*sys.zz(3), 0, 0, 0, 0, 0];
                case 2
                    dh = [0, 0, 0, 0, 0, 0, 0, 1];
            end;
            proj = eye(sys.nstatevars) - (fend * dh)/(dh * fend);
            dg = feval(@dmap06, te(end), ze(end, :)', sys);
            
            % Make discrete state change
            %fprintf('\nMaking discrete state change...');
            sys.zz = feval(@map06, te(end), ze(end, :)', sys);
        else
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
        subparamhist(ecount, :) = sys.zz(sys.index.wxx);
        durhist(ecount) = te;
        vvhist{ecount} = VV;
        
        % Change weights and reset error and subsystem state
        sys.zz(sys.index.wxx) = sys.zz(sys.index.wxx) + -lrate*VV(1, sys.index.wxx)';
        sys.zz(1:3) = sys.zz0(1:3);
        sys.zz(8) = 0;
        sys.zz(sys.index.vari) = reshape(eye(8), 64, 1);
end;

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
figno = 24;
%tspan = [0, 2];
tspan = [0, 0.1];
limits = [-1, 0.1, 1; -1, 0.1, 1];
plottrajectories(reshape(sys.zz(sys.index.wxx), 2, 2), tspan, limits, figno);
figno = 25;
plottrajectories(reshape(sys.zz0(sys.index.wxx), 2, 2), tspan, limits, figno);

%%

fprintf('\n\n');

