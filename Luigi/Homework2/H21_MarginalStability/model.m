% Define transition state matrix
A = [
    1250, -25113, -60050, -42647, -23999;
     500, -10068, -24057, -17092,  -9613;
     250,  -5060, -12079,  -8586,  -4826;
    -750,  15101,  36086,  25637,  14420;
     250,  -4963, -11896,  -8438,  -4756
    ];
% Define transition input matrix
B = [5;
     2;
     1;
    -3;
     1];
% Define output state matrix
C = [-1, 26, 59, 43, 23];
% Define output input matrix
D = [0];

% Create the system model
sys = ss(A, B, C, D);

% Define time horizon `Tf`, time step `step` and create time vector and input vector (null)
Tf = 10;
step = 1.05*(0.32);
time = [0 : step : Tf];
u = zeros(size(time));

% Define initial state
x0 = [1;
     -2;
      3;
     -4;
      5];

% Run simulation
[y, t, x] = lsim(sys, u, time, x0);

% FORWARD EULER APPROXIMATION
% Preallocate output vector as TxM where T is the number of time samples
% and M is the number of equations
n = length(time);
m = length(x0);

fe = zeros(n, m);
be = zeros(n, m);
fe_x_k = x0;
be_x_k = x0;
h=step;
for i = 1 : n
    if i == 1
        x_k = x0;
    end
    % Euler step
    fe_x_k1 = fe_x_k + h*(A*fe_x_k+B*u(i));
    
    % Store state
    fe(i, :) = fe_x_k1;
    
    % Update to next step
    fe_x_k = fe_x_k1;
end

% Compute global error as ||x_anal-x_fe||/||x_anal||
global_error = rdivide(abs(x-fe), abs(x));  % Element-wise division