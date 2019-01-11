%Clear the workspace
clear;

%Declare symbolic variables
syms x;

%Define zero-crossing function
f = 5*sin(x) - log(1+x^2) - 3;

%Define first attempt (starting point)
x0 = 0;

%Newton Iteration algorithm
NI = met.NewtonIteration(f, x0);
NI = NI.run();

%Print solution
%% TODO