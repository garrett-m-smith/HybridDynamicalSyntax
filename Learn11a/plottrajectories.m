function plottrajectories(ww, tspan, limits, figno)

%% Plot trajectories of a two dimensional, linear dynamical system

% limits = [-1, 0.1, 1; -1, 0.1, 1];  % [xlimits; ylimits]
% ww =[2, 2; 2, 2];
% tspan = [0, 2];
% plottrajectories(ww, tspan, limits, 10);


%dt = 0.1;
dt = 0.01;
nsteps = 1000;

xinc = limits(1, 2);
yinc = limits(2, 2);
xrange = limits(1, 1):xinc:limits(1, 3);
yrange = limits(2, 1):yinc:limits(2, 3);

ntraj = length(xrange)*length(yrange);

figure(figno);
clf;
axes('Box', 'on', 'FontSize', 18);
axis([xrange(1), xrange(end), yrange(1), yrange(end)]);
hold on;

fprintf('\n\nPlotting flow...');

fprintf('\n\nOf %d:  ', ntraj);
tcount = 0;
for (ax = xrange)
    for (ay = yrange)
        tcount = report(tcount, 20);
        
        aa0 = [ax; ay];
        %ahist = integratehbtan(aa0, ww, dt, nsteps);
        [tsteps, ahist] = ode45(@linearslope, tspan, aa0, [], ww);
        
        plot(ahist(:, 1), ahist(:, 2));
        text(ahist(end, 1), ahist(end, 2), 'o', 'Color', 'r');
    end;
end;
xlabel('Dimension 1');
ylabel('Dimension 2');
title('Sample trajectories.   Red circles mark last points plotted.');


fprintf('\n');

