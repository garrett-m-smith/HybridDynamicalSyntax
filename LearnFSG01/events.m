function [value, isterminal, direction] = events(tt, zz, sys)
% function [value, isterminal, direction] = events(tt, zz)

% Stopping criterion for learning FSG01

crit = 0.05;
% value = [zz(3)*(1- zz(3)) - crit, zz(5) - 39];
% value = [sqrt((0 - zz(s.index.act1)^2 + (1 - zz(s.index.act2)^2))) - crit, zz(s.index.time) - 39];
value = [sqrt((0 - zz(3)^2 + (1 - zz(4)^2))) - crit, zz(5) - 39];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0