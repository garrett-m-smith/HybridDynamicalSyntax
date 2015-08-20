function dfmat = dfield06(tt, zz, sys)

% DFIELD (partial derivatives of field functions with respect to field
% variables)

dfmat = zeros(sys.nstatevars,sys.nstatevars);

dfmat(1, sys.index.xx) = 2*zz(sys.index.xx);
%dfmat(1, sys.index.xx) = 1.99*zz(sys.index.xx);  % Purposeful error for testing testjacVV

dfmat(sys.index.xx, sys.index.xx) = reshape(zz(sys.index.wxx), sys.nxx, sys.nxx);

windex = 0;
for (ccount = 1:sys.nxx)
    for (rcount = 1:sys.nxx)
        windex = windex + 1;
        dfmat(sys.index.xx(rcount), sys.index.wxx(windex)) = zz(sys.index.xx(ccount));
    end;
end;
