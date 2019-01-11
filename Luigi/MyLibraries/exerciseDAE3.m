% Given the circuit described by the following equations
% u1 = r1*i1
% u2 = r2*i2
% u3 = r3*i3
% u4 = r4*i4
% uc = 1/C * (dic/dt)
% i1 = i2 + ic
% i3 + ic = i4
% u1 + u2 = 5
% u3 + u4 = 5
% u1 + uc + u4 = 5
% Once causalized, applying Tearing algorithm 2 times
% I can simulate such circuit in the following way
% u1 = solve_with_newton_iteration(...)
% u3 = solve_with_newton_iteration(...)
% u4 = 5 - u3
% uc = 5 - u1 -u4
% dic/t = 0*ic + C*uc

% Simulation parameters
[t0, h, tf] = getTimeParameters();
x0 = getInitialState();

[dae_time, dae_x, dae_y] = simulateCircuit(t0, h, tf, x0);
plot(dae_time, dae_x);
hold on;
plot(dae_time, dae_y);
title("DAE Simulation");

function [time, x, y] = simulateCircuit(t0, h, tf, x0)
    % Circuit parameters
    [R1, R2, R3, R4] = initializeResistors();
    C = initializeCapacitors();
    
    % Set up equation for NI
    syms ic u3 u1
    f1 = R3*ic + ((R3-R4)/R4)*u3 - 5*(R3/R4);
    f2 = R1*ic - ((R1+R2)/R2)*u1 + 5*(R1/R2);
    
    time = t0:h:tf;
    x = -1 * ones(size(time,2), 1);
    y = -1 * ones(size(time,2), 1);
    x(1) = x0;
    t = t0;
    i = 1;
    while t<tf
        % Current state
        ic = x(i);
        
        % Algebraic part
        ff1 = subs(f1, "ic", ic);
        ff2 = subs(f2, "ic", ic);
        
        u3 = solve_with_newton(ff1);
        u1 = solve_with_newton(ff2);
        u4 = 5 - u3;
        uc = 5 - u1 - u4;
        
        % Differential part
        d_ic = 0*ic + C*uc;
        xk1 = ic + h*d_ic;
        
        x(i+1) = xk1;
        y(i+1) = uc;
        t = t + h;
        i = i + 1;
    end
end

function val = solve_with_newton(f)
    NI = met.NewtonIteration(f, 0);
    NI = NI.run();
    val = NI.getLastValue();
end

function [t0, h, tf] = getTimeParameters()
    t0 = 0;
    h  = 0.1;
    tf = 20;
end

function [x0] = getInitialState()
    x0 = 0;     %ic(0) = 0
end
       
function [C] = initializeCapacitors()
    C = 1e-1;
end

function [R1, R2, R3, R4] = initializeResistors()
    R1 = 100;
    R2 = 20;
    R3 = 20;
    R4 = 5;
end