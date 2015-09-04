% Run sys_loc for a short time and plot trajectory

clear all; close all;
buildsystem;

sys_loc = sys;
sys_loc.zz = sys_loc.zz0;

njumps = 5;
act1_hist = [];
act2_hist = [];
t_hist = [];
options = odeset('Events', @events, 'AbsTol', 1e-8,'RelTol', 1e-8);

jump_ct = 0;
tstart = 0;

while jump_ct < njumps
    fprintf('\nIntegrating vector field...');
    [tt, zzhist, te, ze, ie] = ode45(@(tt, zz) field(tt, zz, sys_loc), [tstart, sys_loc.timecrit], sys_loc.zz, options); 
    sys_loc.zz = zzhist(end, :)';
    
    if ~isempty(ie)
        temp = field(te(end), ze(end, :)', sys_loc);
        f1 = temp(1:sys_loc.nstatevars); % value of field right at the error surface
        switch ie(end)
            case 1
                fprintf('\nMaking discrete state change...');
                sys_loc.zz = feval(@map, te(end), ze(end, :)', sys_loc); % make the jump
                jump_ct = jump_ct + 1;
            case 2
                jump_ct = jump_ct + 1;
        end;
    end;
    
    act1_hist = [act1_hist, zzhist(:, 3)'];
    act2_hist = [act2_hist, zzhist(:, 4)'];
    t_hist = [t_hist, zzhist(:, 5)'];
    
%     sys_loc.zz(sys_loc.index.input) = binornd(1, 0.5);
%     sys_loc.zz(sys_loc.index.
end;

figure(1);
plot(t_hist, act1_hist);
title('Activation 1 over time');

figure(2);
plot(t_hist, act2_hist);
title('Activation 2 over time');

figure(3);
plot(act1_hist, act2_hist);
title('Phase portrait');