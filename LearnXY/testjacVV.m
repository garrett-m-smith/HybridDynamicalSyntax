% Test Sensitivity Matrix
% Use to make sure the derivatives of the field and map functions are
% entered correctly
% Ratio of top row to bottom row on output should be approx. equal to base
% of perturbation (here, pbase = 10)

%levelmax = 0;
levelmax = 4;

%% Set up system
buildsystem;  % This sets sys.zz0
init0 = sys.zz0(1:sys.nstatevars);

%% Compute end0, i.e., without perturbations

sys = runsystem_sub(sys);
end0 = sys.zz(1:sys.nstatevars);
jacval = reshape(sys.zz(sys.index.vari), sys.nstatevars, sys.nstatevars);

% clevel = 0
% baseendval = end0'
% keyboard;

%% Generate perturbation
% % Test all dimensions at once
pert = rand(sys.nstatevars, 1);
% pert = [1, 0, 0, 0, 0]'; 
% pert(1) = 1: 0.08, 1.1, 0.37
% pert(2) = 1: NaN
% pert(3:4) = 1: 100
% pert(5) = 1: 10
pert = pert/norm(pert);
pbase = 10;

clear('testquant');

levelrange = 1:levelmax;
for clevel = levelrange
    epsi = pbase^(-1-clevel);

    initval = init0;
    initval(1:sys.nstatevars) = init0(1:sys.nstatevars) + epsi*pert;
    sys.zz0(1:sys.nstatevars) = initval;
    pertsys = runsystem_sub(sys);
    endval = pertsys.zz(1:sys.nstatevars); % result of perturbation
    
    testquant(clevel) = norm(endval - end0 - epsi*jacval*pert); 
    % difference between end value with perturbations and the non-perturbed
    % system with the perturbations added at the end
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