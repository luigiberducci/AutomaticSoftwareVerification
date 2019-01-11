% Compute with state space model
[ssm_time, ssm_x] = getGroundTruth();

% Compute as a DAE
[dae_time, dae_x] = getDAESimulation();

% Plot
plot(ssm_time, ssm_x);
hold on;
plot(dae_time, dae_x);
legend("iC");

function [time, x] = getDAESimulation()
    % Parameters
    [R1, R2, R3] = getResistors();
    C = getCapacitance();
    [uB1, uB2] = inputs();
    
    % Simulation params
    [t0, h, tf] = getSimTimeParameters();
    time = getTime(t0, h, tf);
    x = ones(size(time,2), 1)*-1;
    x(1) = 0;
    t = t0;
    i=1;
    
    % Compute NI function
    %syms ic u1;
    %f = (R2+R3) * ic - ((R1+R2+R3)/R1) * u1;
    while t<tf
        ic = x(end);
        
        %Begin Tearing part with NI
        %ff = subs(f, "ic", ic);
        %NI = met.NewtonIteration(ff, 0);
        %NI = NI.run();
        %u1 = NI.getLastValue();
        u1 = (R1*(R2+R3))/(R1+R2+R3) * ic;
        % End Tearing part
        
        uc = uB1 + uB2 - u1;
        d_ic = C*uc;
        
        new_ic = ic + h*d_ic;
        
        % Store the state
        x(i+1, :) = new_ic;
        t = t + h;
        i=i+1;
    end
    x = x(1:end-1,:);
end

function [t, x] = getGroundTruth()
    % Parameters
    [R1, R2, R3] = getResistors();
    C = getCapacitance();

    % State space model of the circuit
    A = [-(R1*(R2+R3))/(R1+R2+R3)      1     1;
                            0 -0.001     0;
                            0      0 0.01];
    x0 = [0; 5; 5];     %iC = 0; uB1=uB2=5;

    %Simulation parameters
    [t0, h, tf] = getSimTimeParameters();

    time = getTime(t0, h, tf);

    % Ground-truth
    anl_sim = simulateAnalyticalSystem(A, t0, h, tf, x0);
    x = anl_sim(1:end-1, 1);
    t = time;
end

function [t] = getTime(t0, h, tf)
    t = t0:h:tf;
end

function [x] = simulateAnalyticalSystem(A, t0, h, tf, x0)
    time = getTime(t0, h, tf);
    x = ones(size(time,2), size(A,1))*-1;
    x(1, :) = x0;
    t = t0;
    i=1;
    while t<tf
        x(i+1, :) = expm(A*t)*x0;
        t = t + h;
        i=i+1;
    end
end

function C = getCapacitance()
    C = 1e-6;
end

function [r1, r2, r3] = getResistors()
    r1 = 100;
    r2 = 20;
    r3 = 5;
end

function [u1, u2] = inputs()
    u1 = 5;
    u2 = 5;
end

function [t0, h, tf] = getSimTimeParameters()
    t0 = 0;
    h  = 0.01;
    tf = 50;
end