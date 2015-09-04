% Run sys_loc for a short time and plot trajectory

% Comment out after training:
clear all; close all;
buildsystem;

%% Initialize:
sys_loc = sys;
sys_loc.zz = sys_loc.zz0;
sys_loc.zz(sys_loc.index.act1) = sys_loc.zz(sys_loc.index.act1) + sys_loc.zz(sys.index.input);

njumps = 5;
act1_hist = [];
act2_hist = [];
t_hist = [];
options = odeset('Events', @events, 'AbsTol', 1e-8,'RelTol', 1e-8);

jump_ct = 0;
tstart = 0;

%% Run:
while jump_ct < njumps
    fprintf('\nIntegrating vector field...');
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys_loc), [tstart, sys_loc.timecrit], sys_loc.zz, options); 
    sys_loc.zz = zzhist(end, :)';
    
    if ~isempty(ie)
        switch ie(end)
            case 1
                fprintf('\nMaking discrete state change...');
                sys_loc.zz = feval(@map, te(end), ze(end, :)', sys_loc); % make the jump
                jump_ct = jump_ct + 1;
            case 2
%                 jump_ct = jump_ct + 1;
                fprintf('Timed out in event function: t = %.3f\n', te);
        end;
    else
        fprintf('Timed out by sys.timecrit (no event)\n');
    end;
    
    act1_hist = [act1_hist, zzhist(:, 3)'];
    act2_hist = [act2_hist, zzhist(:, 4)'];
    t_hist = [t_hist, zzhist(:, 5)'];
    
%     if mod(jump_ct, 2)
%         sys_loc.zz(sys_loc.index.input) = 0.1;
%     else
%         sys_loc.zz(sys_loc.index.input) = 2.1;
%     end;
end;

%% Plotting:
figure(1);
plot(t_hist, act1_hist);
title('Activation 1 over time');

figure(2);
plot(t_hist, act2_hist);
title('Activation 2 over time');

figure(3);
plot(act1_hist, act2_hist);
title('Phase portrait');