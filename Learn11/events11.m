function [value,isterminal,direction] = events11(tt, zz, sys)

% Stopping criterion for learning 2d system

crit = 0.05;
value = [zz(3)*(1- zz(3)) - crit, tt - 1];
isterminal = [1, 1];  
direction = [1, 1];