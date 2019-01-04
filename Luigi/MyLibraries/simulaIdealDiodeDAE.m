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
time = getTimeVector(0, 0.001, 0.1); % Time
u0 = getSinusoidalSignal(time);     % Input

% State-space model
[A, B, C, D] = getModel();
[traj, out] = simulate(A, B, C, D, time, u0, 0);

function [X, Y] = simulate(A, B, C, D, time, u, x0)
    [Ri, RL, C] = getCircuitComponents();
    
    X = [x0];
    Y = [];
        
    m0 = 0;
    u0 = u(1);
    u2 = X(end);
    ev = 1/(m0 + (1-m0)*Ri) * (u0-u2);
    if ev<0
        m0 = 1;
    else
        m0 = 0;
    end
    
    flag = [m0];
    for step = 1:size(time,2)
        u0 = u(step);
        u2 = X(end); 
        ev = 1/(m0 + (1-m0)*Ri) * (u0-u2);
        
        %Check if event triggered
        ev = 1/(m0 + (1-m0)*Ri) * (u0-u2);
        if ev<0
            m0 = 1-m0;
        end
    
        flag(end+1) = m0;
        
        % Next step
        next_u2 = u2 + A(m0)*u2 + B(m0)*u0;
        y = C*u2 + D*u0;
        
        % Append new state and output
        X(end+1) = next_u2;
        Y(end+1) = y;
        
        old_ev = ev;
    end
end

function [A, B, C, D] = getModel()
    syms m0;
    [Ri, RL, C] = getCircuitComponents();
    
    A = (m0*(RL+Ri-1)-Ri)/(C*Ri*RL*(Ri+(1-Ri)*m0));
    B = (Ri*(1-m0))/(C*Ri*(Ri+(1-Ri)*m0));
    C = 1;  % The output is `u2`, then y=1*x+0*u
    D = 0;
    
    A = matlabFunction(A); 
    B = matlabFunction(B);
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

