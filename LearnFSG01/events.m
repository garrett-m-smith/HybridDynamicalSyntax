function [value, isterminal, direction] = events(tt, zz, sys)
% Stopping criterion for learning FSG01

crit = 0.1;
% value = [sqrt((0 - zz(3)^2 + (1 - zz(4)^2))) - crit, zz(5) - 39];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0

% A bit inelegant...
if zz(2) == 0.1
    value = [sqrt((0 - zz(3))^2 + (1 - zz(4))^2) - crit, zz(5) - 39];
else
    value = [sqrt((1 - zz(3))^2 + (0 - zz(4))^2) - crit, zz(5) - 39];
end;