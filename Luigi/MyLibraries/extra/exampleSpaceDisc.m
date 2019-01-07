%% Example of Space Discretization (Book 11.2)
analyticSystem = getAnalyticModel();
[x, y]   = runDefaultSimulationOfSystem(analyticSystem);
[qq, qx, qy] = runQuantizedSystem();

figure(1);
plotTwoFunctions(qq, qx);
legend("Quantized State", "Continuous State");

figure(2);
plotTwoFunctions(x, qx);
legend("Analytical", "Quantized");

function plotTwoFunctions(f, g)
    plotFunctionOfTime(f);
    hold on;
    plotFunctionOfTime(g);
end

function plotFunctionOfTime(f)
    t = getDefaultTimeVector();
    plot(t, f);
end

function [qtrajectory, trajectory, output] = runQuantizedSystem()
    [t, u] = getTimeAndInputVectors();
    [Q, X, Y] = initEmptiesTrajAndOutput(size(t,2)+1);
    q = getQuantumFunction();
    
    X(1) = getDefaultInitialState();
    Q(1) = q(getDefaultInitialState());
    Y(1) = 0;
    
    for i = 1:size(t,2)
        x = X(i);
        Q(i+1) = getQuantNextStateQuantized(x, u(i), t(i));
        X(i+1) = getQuantNextState(x, u(i), t(i));
        Y(i+1) = getQuantNextOutput(x, u(i), t(i));
    end
    
    qtrajectory = Q(1:end-1, :); 
    trajectory = X(1:end-1, :);
    output = Y(2:end, :);
end

function q = getQuantNextStateQuantized(x, u, t)
    q = getQuantumFunction();
    q = q(x); 
end

function x1 = getQuantNextState(x, u, t)
    dx = getDerivative(x, u, t);
    h  = getDefaultStepSize();
    x1 = x + h*dx;      %Forward Euler
end

function dx = getDerivative(x, u, t)
    q = getQuantumFunction();
    dx = -q(x) + 10*u;
end

function [q, e] = getQuantizedDerivativeFunctions()
    q = getQuantumFunction();
    e = getUnitStepFunction();
end

function y = getQuantNextOutput(x, u, t)
    y = x;
end

function [q, x, y] = initEmptiesTrajAndOutput(numSamples)
    x = zeros(numSamples, 1);
    y = zeros(numSamples, 1);
    q = zeros(numSamples, 1);
end

function [trajectory, output] = runDefaultSimulationOfSystem(sys)
    [time, u] = getTimeAndInputVectors();
    [x0] = getDefaultInitialState();
    [output, t, trajectory] = lsim(sys, u, time, x0);
end

function [x0] = getDefaultInitialState()
    x0 = 10;
end
function system = getAnalyticModel()
    [A, B, C, D] = getAnalyticStateSpaceModel();
    system = ss(A, B, C, D);
end

function f = getUnitStepFunction()
    f = @(t) heaviside(t-1.76);
end

function f = getQuantumFunction()
    f = @(x) floor(x);
end

function [time, u] = getTimeAndInputVectors()
    e = getUnitStepFunction();
    time = getDefaultTimeVector();
    u = arrayfun(e, time);
end
function [A, B, C, D] = getAnalyticStateSpaceModel()
    A = -1;
    B = 10;
    C  = 1;
    D  = 0;
end

function [time] = getDefaultTimeVector()
    [t0, h, tf] = getTimeConstants();
    time = getTimeVector(t0, h, tf);
end

function [time] = getTimeVector(t0, h, tf)
    time = [t0 : h : tf];
end
    
function [t0, h, tf] = getTimeConstants()
    t0 = 0;
    h  = getDefaultStepSize(); 
    tf = 5;
end

function h = getDefaultStepSize()
    h = 0.01;
end