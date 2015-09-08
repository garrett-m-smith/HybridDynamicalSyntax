function devmat = devfsg(tt, zz, sys)
% Returns Jacobian (1 x nstatevars matrix) of event fn. wrt. ea. of the state variables

devmat = zeros(1, sys.nstatevars);
syms err input1 input2 input3 act1 act2 time
evfn = sqrt((0 - act1)^2 + (1 - act2)^2) * sqrt((2.1 - act1)^2 + (0 - act2)^2) * sqrt((0.2 - act1)^2 + (0.2 - act2)^2);

% need to figure out how to get a double-precision out of this jacobian
s = jacobian(evfn, [err, input1, input2, input3, act1, act2, time])%, [zz(5), zz(6)];
devmat = double(s);