clear all;
clc;

% Matrix A of LTI system dx = Ax
%A = [-20 1; 0 -20];
%x0 = [10; 10];
A = [-1 0; 0 -2];
x0 = [10; -10];

% Define State quantum
quantum = 0.01;

myQSS = sim.QSS(quantum, A, x0);

% Simulate
t0 = 0;
tf = 20;
t = t0;
while t<tf
    myQSS = myQSS.step();
    t = myQSS.time_vector(end);
end

time = myQSS.time_vector(1:end-1);
x = myQSS.trajectory(2:end-1, :);
qx = myQSS.q_trajectory(2:end-1, :);
dxx = myQSS.dx_trajectory(2:end-1, :);

%figure(10);
%plot(time, x);
%title("Trajectory");

figure(20);
stairs(time, qx);
title("Quantized Trajectory");
legend("x1", "x2");