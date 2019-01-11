clear all;
clc;

[t0, tf] = getTimes();
h = 0.1;
x0 = getInitialState();

[dae_time, dae_x] = simulateDAE(t0, h, tf, x0);
[anl_time, anl_x] = simulaAnalytically(t0, h, tf, x0);

subplot(1,2,1);
plot(dae_time, dae_x);
legend();
title("DAE Simulation");

subplot(1,2,2);
plot(anl_time, anl_x);
legend();
title("ODE Simulation");

function [time, x] = simulateDAE(t0, h, tf, x0)
    time = t0:h:tf;
    x = -1*ones(size(time,2), 2);
    
    i = 1;
    t = t0;
    x(1,:) = getInitialState();
    
    C = getCapacitor();
    L = getInductance();
    [R1, R2] = getResistors();
    u0 = 5;
    while t<tf
        xk = transpose(x(end, :));
        x1 = xk(1);
        x2 = xk(2);
        
        u2 = x2;
        i2 = 1/R2 * u2;
        u1 = u0-x2;
        u1 = u0-x2;
        i1 = 1/R1 * u1;
        u3 = u1 + u2;
        
        xx1 = x1 + h*(1/L*u3);
        
        i0 = i1 + x1;
        i3 = i0 - i1;
        
        xx2 = x2 + h*(1/C*i3);

        x(i+1, :) = [xx1; xx2];
        i = i+1;
        t = t+h;
    end
end

function [time, x] = simulaAnalytically(t0, h, tf, x0)
    A = getODEMatrix();
    time = t0:h:tf;
    x = -1*ones(size(time,2), 2);
    
    i = 1;
    t = t0;
    x(1,:) = getInitialState();
    xx0 = [getInitialState(); 5];
    while t<tf
        xk1 = expm(A*t)*xx0;
        x(i+1, :) = xk1(1:2);
        i = i+1;
        t = t+h;
    end
end

function [A] = getODEMatrix()
    C = getCapacitor();
    L = getInductance();
    
    A = [  0  0 1/L;
         1/C  0   0;
           0  0   0];
end

function [t0, tf] = getTimes()
    t0 = 0;
    tf = 50;
end

function [x0] = getInitialState()
    x0 = [0;    %x1
          0];   %x2
end

function [r1, r2] = getResistors()
    r1 = 100;
    r2 = 20;
end

function [C] = getCapacitor()
    C = 1e-3;
end

function [L] = getInductance()
    L = 0.01;
end