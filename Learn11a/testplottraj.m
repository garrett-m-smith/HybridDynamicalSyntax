limits = [-1, 0.1, 1; -1, 0.1, 1];  % [xlimits; ylimits]
% ww =[1, 0;
%      0, 1];
ww = [1, -1;
      2,  2];
% ww = [0, 0;
%       0, 0];
% ww = [-1,  0;
%        0, -1];
   
tspan = [0, 0.1];
figno = 10;

plottrajectories(ww, tspan, limits, figno);
  