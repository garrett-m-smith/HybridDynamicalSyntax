function [value, isterminal, direction] = eventsX(tt, zz, sys)

% Stopping criterion for getting close to X fixed point

value = [zz(sys.index.act) - zz(sys.index.eventX), zz(sys.index.time) - zz(sys.timecrit)];
isterminal = [1, 1]; % event should terminate when value(1) or tt - 1 = 0
direction = [0, 1]; % says value fn. should just = 0