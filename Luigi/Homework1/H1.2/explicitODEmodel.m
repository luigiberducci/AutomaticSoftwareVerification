T0 = 0;
Tf = 100;
h  = 0.01;

% Matrices
A  = [
     0  1  0  0;
     0  0  1  0;
     0  0  0  1;
    -2 -3 -4 -5
];
b  = [0; 0; 0; 1];
ct = [1 0 0 0]; 
d  = 10;

% Initial state
x0 = ones(4,1);

% Time vector
time = [T0:h:Tf];

% Input signal
u = 5*sin(2*time);

% Create the Single-input Single-output continuous-time model
SISO_CTS = ss(A, b, ct, d);

% Simulate CTS (Use it as reference)
[y, t, x] = lsim(SISO_CTS, u, time);

% FORWARD EULER
fe_x = zeros(length(time), length(A));
for i = 1:length(time)
    % Base case, x_k is the initial state
    if i==1
        x_k = x0;
    end
    % Compute the next state
    x_k1 = x_k + h*(A*x_k+b*u(i));
    % Keep track of the state
    fe_x(i, :) = x_k1; 
    % Update the previous state for next iteration
    x_k = x_k1;
end