% System described by the following equations:
% uB1 = f(t)
% i2  = iC2
% u2  = R2*i2
% i1  = iC1 - i2
% u1  = R1*i1
% uC1 = uB1 - u1
% diC1/dt = C1*uC1
% uC2 = u1-u2
% diC2/dt = C2 * uC2
% Once causalized (without Tearing, just apply Tarjan), I obtained the
% following ODE:
%
% diC1    -C1R1   +C1R1       iC1     C1
%      =                           +      uB1
% diC2     C2R1   -C2(R1+R2)  iC2      0
%
% Simplify including constant input uB1 in the state representation.

% Circuit parameters
[C1, C2] = initializeCapacitors();
[R1, R2] = initializeResistors();

A = [ -C1*R1,       C1*R1,    C1;
       C2*R1, -C2*(R1+R2),     0;
           0,           0,  -0.1];

% Simulation parameters
[t0, h, tf] = getTimeParameters();
[x0] = getInitialState();

% Analytical solution
[anl_time, anl_sim] = simulateAnalytically(A, t0, h, tf, x0);

% ODE Simulation
[ode_time, ode_sim] = simulateODE(A, t0, h, tf, x0);

% DAE Simulation
[dae_time, dae_sim] = simulateDAE(A, t0, h, tf, x0);

% Plot
subplot(1, 2, 1);
plot(dae_time, dae_sim);
title("DAE Simulation");

subplot(1, 2, 2);
plot(ode_time, ode_sim);
title("ODE Simulation");


function [t, x] = simulateDAE(A, t0, h, tf, x0)
    % Notice: A never used, it is called only to have a uniform signature
    % Parameters
    [C1, C2] = initializeCapacitors();
    [R1, R2] = initializeResistors();
    
    % Initial state
    iC1 = x0(1);
    iC2 = x0(2);
    uB1 = x0(3);
    
    % ODE component, state = [iC1; iC2]
    AA = [ C1,  0,   0;
           0,  C2,   0;
           0,   0,-0.1];
    
    % Simulation
    t = t0 : h : tf;
    currTime = t0;
    i = 1;
    x = -1*ones(size(t, 2), size(AA, 1));
    x(1, :) = [iC1, iC2, uB1];
    while currTime+h<=tf
        xk = transpose(x(i, :));
        iC1 = xk(1);
        iC2 = xk(2);
        uB1 = xk(3);
        
        % Algebraic part
        i2 = iC2;
        u2 = R2*i2;
        i1 = iC1 - i2;
        u1 = R1*i1;
        uC1 = uB1 - u1;
        uC2 = u1 - u2;
        
        % Differential part (Forward Euler)
        z = [uC1; uC2; uB1];
        xk1 = xk + h*AA*z;
        
        x(i+1, :) = xk1;
        currTime = currTime + h;
        i = i+1;
    end
end

function [t, x] = simulateODE(A, t0, h, tf, x0)
    algo = "FE";
    SimManager = sim.SimulatorFactory(algo, A, h, x0);
    SimManager = SimManager.simulate(t0, tf);
    
    t = SimManager.getTimeVector(t0, tf);
    x = SimManager.sim.getTrajectory();
end

function [t, x] = simulateAnalytically(A, t0, h, tf, x0)
    algo = "FE";
    SimManager = sim.SimulatorFactory(algo, A, h, x0);
    
    x = SimManager.simulateAnalytical(t0, tf);
    t = SimManager.getTimeVector(t0, tf);
end

function [t0, h, tf] = getTimeParameters()
    t0 = 0;
    h  = 0.1;
    tf = 200;
end

function [x0] = getInitialState()
    x0 = [0;    %iC1(0) = 0 
          0;    %iC2(0) = 0
          5];   %uB1(0) = 5
end
       
function [C1, C2] = initializeCapacitors()
    C1 = 1e-1;
    C2 = 1e-3;
end

function [R1, R2] = initializeResistors()
    R1 = 100;
    R2 = 20;
end
