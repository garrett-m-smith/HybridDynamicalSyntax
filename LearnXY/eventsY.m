function [value, isterminal, direction] = eventsY(tt, zz, sys)
% Stopping criterion for getting close to Y fixed point

value = [zz(sys.index.act) - zz(sys.index.eventY), zz(sys.index.time) - zz(sys.timecrit)];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0