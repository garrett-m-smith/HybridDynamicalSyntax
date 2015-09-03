function [value,isterminal,direction] = events(tt, zz, sys)

% Stopping criterion for learning FSG01

crit = 0.05;
% value = [zz(3)*(1- zz(3)) - crit, zz(5) - 39];
value = [sqrt((0 - zz(sys.index.act1)^2 + (1 - zz(sys.index.act2)^2))) - crit, zz(sys.index.time) - 39];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0