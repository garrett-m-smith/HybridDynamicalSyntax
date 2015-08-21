function [value,isterminal,direction] = events11(tt, zz, sys)

% Stopping criterion for learning 2d system

crit = 0.05;
value = [zz(3)*(1- zz(3)) - crit, zz(5) - 1];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [1, 1]; % says value fn. should be increasing when it = 0