function [value,isterminal,direction] = events06(tt, zz, sys)

% Stopping criterion for learning 2d system

radsquared = 4;
value = [zz(2)^2 + zz(3)^2 - radsquared, tt - 1];
  % Note:  a range of values for radsquared works:  at least [0.1, 4.2]
  % works
%value = [zz(2)^2 + zz(3)^2 - 9, tt - 1]; % This causes it to time out on every trial and blow up
% all the time
%value = [zz(2)^2 + zz(3)^2 - 4, tt - 0.01];
%value = [zz(3), tt - 1]; 
%value = [norm([zz(2), zz(3)]) - 2, tt - 1];     % Detect criterion
isterminal = [1, 1];   % Stop the integration
%direction = [1, 1];   % From below(assumes starts closer to origin); from below for time cutoff
direction = [1, 1];