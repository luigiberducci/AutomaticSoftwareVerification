% Dummy Discrete Time System
% x(k+1) = x(k) + u(k)
% y(k+1) = x(k)
%
% The basic idea is to formalize a safety specification s.t.
% G [x(k) < UPPERBOUND], where UPPERBOUND = tf
% By construction, y(k) = x(k) and 
% only the input vector [1,1,1,...,1] can falsify this specification
% and then, a Uniform Random Sampling has a very low chance to
% falsify the specification.
%
% Requirements:
% -------------
%       `rand_input` MATLAB function which return input vector
t = 1;
tf = 10;

A = [1];
B = [1];
C = [1];
D = [0];

system = ss(A, B, C, D, t);

time = [0:t:tf];
u = rand_input(tf, t);

[y, t, x] = lsim(system, u, time);