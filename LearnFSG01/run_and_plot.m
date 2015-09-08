%% Run sys_loc for a short time and plot trajectory
% Goal: provide input symbols, look up params in array. 

% Comment out after training:
clear all; close all;
buildsystem;

%% Set up small fragment of XYZ language
order_mat = [-1, -1; % X
             1, 0.1; % Y
             -1, -1; % X
             0.1, 1; % Z
             -1, -1; % X
             0.1, 1]; % Z

%% Initialize:
sys_loc = sys; % local copy of sys
sys_loc.zz = sys_loc.zz0;

njumps = nrows(order_mat);
act1_hist = [];
act2_hist = [];
t_hist = [];
options = odeset('Events', @eventsfsg, 'AbsTol', 1e-8,'RelTol', 1e-8);

jump_ct = 0;
tstart = 0;

%% Run:
for jump_ct = 1:njumps
    % Set input:
    sys_loc.zz(sys.index.input) = order_mat(jump_ct, :);
    
    fprintf('Integrating vector field...\n');
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys_loc), [tstart, sys_loc.timecrit], sys_loc.zz, options); 
    sys_loc.zz = zzhist(end, :)';
    
    if ~isempty(ie)
        switch ie(end)
            case 1
                fprintf('Making discrete state change...\n');
                sys_loc.zz = feval(@map, te(end), ze(end, :)', sys_loc); % make the jump
                jump_ct = jump_ct + 1;
            case 2
                fprintf('Timed out in event function: t = %.3f\n', te);
        end;
    else
        fprintf('Timed out by sys.timecrit (no event)\n');
    end;
    
    % Saving trajectories
    act1_hist = [act1_hist, zzhist(:, sys_loc.index.act1)'];
    act2_hist = [act2_hist, zzhist(:, sys_loc.index.act2)'];
    t_hist = [t_hist, zzhist(:, sys_loc.index.time)'];
end;

%% Plotting:
figure(1);
plot(t_hist, act1_hist);
title('Activation 1 over time');
xlabel('Time');
ylabel('act_1');

figure(2);
plot(t_hist, act2_hist);
title('Activation 2 over time');
xlabel('Time');
ylabel('act_2');

figure(3);
plot(act1_hist, act2_hist);
title('Phase portrait');
xlabel('act_1');
ylabel('act_2');