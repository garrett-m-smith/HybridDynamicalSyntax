% Test Sensitivity Matrix

%levelmax = 0;
levelmax = 4;

%% Set up system
buildsystem06;  % This sets sys.zz0

%% Specify a long time interval so criterion surface is reached (for testing full process)
%  NOTE:  this must be done by hand in events06

%% Set initial state
init0 = [0; sys.xx0; reshape(sys.wxx0, 4, 1); 0];
sys.zz0(1:sys.nstatevars) = init0;

%% Compute end0

[VV, sys.zz, phi06] = runsystem06sub(sys);
end0 = sys.zz(1:sys.nstatevars);
jacval = VV;



%% Generate perturbation
% % Test all dimensions at once
pert = rand(sys.nstatevars, 1);
pert = pert/norm(pert);

% Test one dimension at a time
% pert = ibit(2, sys.nstatevars);
%% Note:  testing time (the last statevar) seems to result in a division by 0

pbase = 10

%pert = ibit(8, sys.nstatevars);

clear('testquant');

levelrange = 1:levelmax;
for (clevel = levelrange)
    epsi = pbase^(1-clevel);

    initval = init0;
    initval(1:sys.nstatevars) = init0(1:sys.nstatevars) + epsi*pert;
    sys.zz0(1:sys.nstatevars) = initval;
    [pertVV, pertsys.zz, pertphi] = runsystem06sub(sys);
    endval = pertsys.zz(1:sys.nstatevars);
    
    testquant(clevel) = norm(endval - end0 - epsi*jacval*pert);   
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

jacval06 = jacval;
pert06 = pert;
endzero06 = end0;
endval06 = endval;

    