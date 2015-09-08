function [value, isterminal, direction] = eventsfsg(tt, zz, sys)
% Stopping criterion for learning FSG01

crit = 0.1;
% value = [sqrt((0 - zz(5))^2 + (1 - zz(6))^2) - crit, zz(7) - 50]; % (0,1)
% value = [sqrt((2.1 - zz(5))^2 + (0 - zz(6))^2) - crit, zz(7) - 50]; %(2.1,0)
% value = [sqrt((0.2 - zz(5))^2 + (0.2 - zz(6))^2) - crit, zz(7) - 50]; %(.2,.2)

% Distance measure: approaching any fixed point makes this error fn.
% approach 0
dist_measure = sqrt((0 - zz(5))^2 + (1 - zz(6))^2) * sqrt((1 - zz(5))^2 + (0 - zz(6))^2) * sqrt((0 - zz(5))^2 + (0 - zz(6))^2);
value = [dist_measure - crit, zz(7) - 50];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0