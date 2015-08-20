sys.statecrit = 0;
sys.timecrit = 1;
sys.wxx0 = [2, 0;
            0, 2];  % Weights
sys.xx0 =  [-0.2; 0.4];  % Initial state of activation variables 
%sys.xx0 = [0.02; 0.04];
%sys.xx0 = [-0.2; 0.2];
%sys.xx0 = [0.18; 0.18];
%sys.xx0 = [0; 0.2];  % This case stumps it (a degenerate case?)
%sys.jumpsize = 1;
sys.jumpsize = 0.1;
% sys.wxx0 = [1, 2;
%             4, -2];
%sys.xx0 =  [-2; 1];
%sys.jumpsize = 3;
   
sys.index.error = 1;
sys.index.xx = 2:3;
sys.index.wxx = 4:7;
sys.index.time = 8;
sys.index.vari = 9:72;

sys.nvars = sys.index.vari(end);
sys.nstatevars = sys.index.vari(1)-1;
sys.nxx = length(sys.index.xx);

sys.zz0 = zeros(sys.nvars, 1);
% Initialize state variables:
sys.zz0(1:sys.nstatevars) = [0; sys.xx0; reshape(sys.wxx0, 4, 1); 0];
% Initialize variational variables:
sys.zz0(sys.index.vari) = reshape(eye(sys.nstatevars), sys.nstatevars^2, 1);
