function [value, isterminal, direction] = eventsfsg(tt, zz, sys)
% Stopping criterion for learning FSG01

crit = 0.05;
% Distance measure: approaching any fixed point makes this error fn.
% approach 0
% Could also try velocity = magnitude of vec field at current point
dist_measure = sqrt((0 - zz(4))^2 + (1 - zz(5))^2) * sqrt((1 - zz(4))^2 + (0 - zz(5))^2) * sqrt((0 - zz(4))^2 + (0 - zz(5))^2);
value = [dist_measure - crit, zz(7) - 149];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0