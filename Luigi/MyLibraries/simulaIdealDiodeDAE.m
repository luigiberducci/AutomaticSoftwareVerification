%% Try to simulate the Half-way rectifier circuit (Figure 9.27).
%  Starting from the circuit equations:
%  u0 = f(t)
%  u1 = Ri*i0
%  u2 = RL*iR
%  iC = C*(du2/dt)
%  u0 = u1 + ud + u2
%  i0 = iC + iR
%  ud = m0*s
%  i0 = (1-m0)*s
%  Causalize the system applying Tearing algorithm with `s` as Tearing
%  variable:
%  iR = 1/RL*u2
%  ud = m0*s
%  u1 = u0 - ud - u2
%  i0 = 1/Ri*u1
%  s  = 1/(1-m0) * i0
%  iC = i0-iR
%  du2/dt = 1/C*iC
%  Since switch equation is not solvable because `division by 0` may occurs,
%  solve the residual equations for `s` using substituation technique:
%  s = 1/(m0 + (1-m0)*Ri) * (u0-u2)
%  Then convert the causalized DAE to ODE by sostitution:
%  du2 = A*u2 + B*u0
%  where A = (m0*(RL+Ri-1)-Ri)/(C*Ri*Rl*(Ri+(1-Ri)m0))
%  and   B = (Ri*(1-m0))/(C*Ri*(Ri+(1-Ri)*m0))

% Simulation parameters
time = getTimeVector(0, 0.01, 0.1); % Time
u0 = getSinusoidalSignal(time);     % Input

% State-space model
[A, B] = getModel();

function [x] = simulate(A, B, time, u, x0)
    syms m0;
    [Ri, RL, C] = getCircuitComponents();
    
    x = [x0];
    for step=1:size(time,1)
        u0 = u(step);
        u2 = x(end); 
        ev = 1/(m0 + (1-m0)*Ri) * (u0-u2);
        
        % IF pre(ev)==0 and ev==1 then event occurred
        % Then change m0
        
        % Next step
        
        % Append new state
    end
end

function [A, B] = getModel()
    syms m0;
    [Ri, RL, C] = getCircuitComponents();
    
    A = (m0*(RL+Ri-1)-Ri)/(C*Ri*RL*(Ri+(1-Ri)*m0));
    B = (Ri*(1-m0))/(C*Ri*(Ri+(1-Ri)*m0));
    
end

function [U] = getSinusoidalSignal(time)
    f = @(x) sin(5*x);
    U = arrayfun(f, time);
end

function [time] = getTimeVector(t0, h, tf)
    time = [t0 : h : tf];
end

function [Ri, RL, C] = getCircuitComponents()
    Ri = 10;
    RL = 50;
    C  = 0.001;
end

