LW = 'LineWidth';
lw = 1;

[x,y] = meshgrid(-3:0.1:3);    % Define the hl-plane
z=x+i*y;                        % z contains all complex number

% Forward Euler
figure(1);
title("Forward Euler Stability Region");
FE = 1 + z;

zlevel = abs(FE);               % I don't know what is this line
contour(x, y, zlevel, [1 1]);   % Display the first contour ([1 1])

% Heun's Method
figure(2);
title("Heun's Method Stability Region");
HE = 1 + z + (z^2)/2;
zlevel = HE;               % I don't know what is this line
contour(x, y, zlevel);   % Display the first contour ([1 1])
