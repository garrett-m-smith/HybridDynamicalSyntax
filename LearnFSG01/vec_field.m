% Exercise: generate vector field for 2D ODE using ode45

sys.zz = sys.zz0;

z1 = linspace(0, 2.2, 20); % similar to a:step:b
z2 = linspace(0, 1, 20);
[x, y] = meshgrid(z1, z2);
dz1 = zeros(size(x));
dz2 = zeros(size(x));

tt = 0;
for i = 1:numel(x) 
    % cycles through matrix by row, then column.
    sys.zz(sys.index.act1) = x(i);
    sys.zz(sys.index.act2) = y(i);
    dz = field(tt, sys.zz, sys); % get vector for ea. pt.
    dz1(i) = dz(sys.index.act1);
    dz2(i) = dz(sys.index.act2);
end

% for ea. (x, y) coord, plot vector given by (dz1, dz2)
% tail of ea. vector is put at (x, y), length is scaled to fit the grid
figure(4);
quiver(x, y, dz1, dz2, 3, 'b');
xlabel('act_1');
ylabel('act_2');
