function dfmat = dfield11(tt, zz, sys)

% DFIELD (partial derivatives of field functions with respect to field
% variables)
% Double checked: seem ok

dfmat = zeros(sys.nstatevars,sys.nstatevars);

dfmat(1, 2) = -2*zz(3) + 1;
dfmat(1, 3) = 2*zz(3) - 2*zz(2);
%dfmat(1, 3) = 2*zz(3);    % A simple case, for testing

dfmat(3, 2) = 2*zz(3)*zz(4) - 2*zz(3)^2*zz(4);
%dfmat(3, 3) = 2*zz(2)*zz(4) - zz(4) - 4*zz(2)*zz(3)*zz(4) + 2*zz(3)*zz(4);
dfmat(3, 3) = zz(4)*(2*zz(2) - 1 - 4*zz(2)*zz(3) + 2*zz(3));
dfmat(3, 4) = zz(3)*(1 - zz(3))*(2*zz(2) - 1);
%dfmat(3, 3) = 1 - 2*zz(3);  % A simple case for testing