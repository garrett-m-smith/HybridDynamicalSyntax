% Test Sensitivity Matrix
% Use to make sure the derivatives of the field and map functions are
% entered correctly
% Ratio of top row to bottom row on output should be approx. equal to base
% of perturbation (here, pbase = 10)

%levelmax = 0;
levelmax = 4;

%% Set up system
buildsystem;  % This sets sys.zz0

%% Specify a long time interval so criterion surface is reached (for testing full process)
%  NOTE:  this must be done by hand in events06

%% Set initial state
init0 = sys.zz0(1:sys.nstatevars);

%% Compute end0

sys = runsystem_sub(sys);
end0 = sys.zz(1:sys.nstatevars);
jacval = reshape(sys.zz(sys.index.vari), 5, 5);

% clevel = 0
% baseendval = end0'
% keyboard;

%% Generate perturbation
% % Test all dimensions at once
% pert = rand(sys.nstatevars, 1);
pert = [0, 1, 0, 0, 0]'; % second row w/ 1 leads to 0s and NaN; last elem = 1 ~> 10 instead of 100
pert = pert/norm(pert);

% Test one dimension at a time
%pert = ibit(1, sys.nstatevars);  
%% Note:  testing time (the last statevar) seems to result in a division by 0

pbase = 10;

%pert = ibit(8, sys.nstatevars);

clear('testquant');

levelrange = 1:levelmax;
for (clevel = levelrange)
    epsi = pbase^(-2-clevel);

    initval = init0;
    initval(1:sys.nstatevars) = init0(1:sys.nstatevars) + epsi*pert;
    sys.zz0(1:sys.nstatevars) = initval;
    pertsys = runsystem_sub(sys);
    endval = pertsys.zz(1:sys.nstatevars);
    
    testquant(clevel) = norm(endval - end0 - epsi*jacval*pert);  

    
%     clevel
%     pertendval = endval'
%     keyboard;
end;

if length(levelrange) > 0
    epsi0 = 10^(-levelrange(1));
end;
fprintf('\n');
for (clevel = levelrange)
   fprintf('%12.8f', testquant(clevel));
end;
fprintf('\n');
for (clevel = levelrange(1:(end-1)))
   fprintf('%12.2f', testquant(clevel)/testquant(clevel+1));
end;
fprintf('\n\n');

% jacval06 = jacval;
% pert06 = pert;
% endzero06 = end0;
% endval06 = endval;

    