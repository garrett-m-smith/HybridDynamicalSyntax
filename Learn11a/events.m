function [value,isterminal,direction] = events11(tt, zz, sys)

% Stopping criterion for learning 1d system

crit = 0.05;
value = [zz(3)*(1- zz(3)) - crit, zz(5) - 39];
% value = [zz(3) - crit, zz(5) - 39];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0