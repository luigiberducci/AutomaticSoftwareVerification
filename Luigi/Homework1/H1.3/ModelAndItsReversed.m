T0 = 0;
Tf = 100;
h  = 0.01;

% Matrices Original system
A  = [
     0  1  0  0;
     0  0  1  0;
     0  0  0  1;
    -2 -3 -4 -5
];
b  = [0; 0; 0; 1];
x0 = ones(4,1);

% Matrices Reverse system
Ar = -A;
br  = -b;

% Time vector
time = [T0:h:Tf];
rev_time = Tf - time;

% Input signal
u = 5*sin(2*time);

% Create the Single-input Single-output continuous-time model
Normal_system = ss(A, b, zeros(length(A)), 0);
Reversed_system = ss(Ar, br, zeros(length(A)), 0);

% Simulate Original system
[y, t, x] = lsim(Normal_system, u, time);
xr0 = x(length(x));     % xr(T0) = x(Tf)
% Simulate Reversed system  IT DOESN'T WORK BECAUSE TIME VECTOR MUST BE MONOTICALLY ASCENT
%[yr, tr, xr] = lsim(Reversed_system, u, rev_time);
