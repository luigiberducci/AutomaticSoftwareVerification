classdef QSS < sim.Simulator
    %QSS Trivial implementation of QSS for LTI systems simulation.
    %   Implementation based on Algorithm 1 (page 3) by Parallel QSS paper.
    
    properties
        n           % Size of state variable
        q           % Quantum vector
        next_times  % Next time where each state variable changes quantum
        last_update % Time of the last update for each variable
        q_trajectory
        dx_trajectory
        time_vector
        maxTime
    end
    
    methods
        function obj = QSS(q, A, x0)
            %QSS Construct an instance of this simulator
            % Invoke the superclass' constructor
            obj = obj@sim.Simulator(0, A, x0);
            
            n = size(A, 1);     % Number of state variables
            if size(q, 1) < n
                obj.q = ones(n, 1) * q;
            else
                obj.q = q;
            end
            obj.next_times  = zeros(n, 1);
            obj.last_update = zeros(n, 1);
            obj.q_trajectory(1, :) = x0;
            obj.dx_trajectory = zeros(1, n);
            for i = 1:n
                obj.dx_trajectory(1, i) =obj.diffi(i, floor(x0));
            end
            
            obj.n = n;
            obj.time_vector = [];
            obj.maxTime = Inf;
        end
       
        function obj = step(obj)
            %STEP Step ahed the simulation
            [t, i] = min(obj.next_times);
            
            %Take the last state, the quantized state and the derivative
            [x, qx, dx] = obj.getLastX_Q_dX();
            
            % Compute the state up to now
            xi = qx(i);
            elap_xi = t - obj.last_update(i);
            xi = xi + dx(i)*elap_xi;
            x(i) = xi;
            
            % Since i-th var is changing the quantum, it update q
            qx(i) = xi;
            
            % Compute the next time that i-th will change the quantum
            dx(i) = obj.diffi(i, qx);
            obj.next_times(i) = obj.getNextTime1(i, x, qx, dx, t);
            
            for j = 1:obj.n
                if not(j==i)
                    elap_xj = t - obj.last_update(j);
                    xj = qx(j);                    
                    xj = xj + dx(j)*elap_xj; %Where I am
                    x(j) = xj;
                    dx(j) = obj.diffi(j, qx);
                    obj.last_update(j) = t;
                    obj.next_times(j) = obj.getNextTime2(j, x, qx, t);
                end
            end
            
            obj.last_update(i) = t;
            obj.trajectory(end+1, :) = x;
            obj.q_trajectory(end+1, :) = qx;
            obj.dx_trajectory(end+1, :) = dx;
            obj.numberOfSteps = obj.numberOfSteps+1;
            
            obj.time_vector(end+1) = t;
        end
        
        function tt = getNextTime1(obj, i, x, q, dx, t)
            deltaQ = obj.q(i);
            xi = x(i);
            qi = q(i);
            dxi = dx(i);
            epsilon = 1e-9;
            
            h = deltaQ/(abs(dxi) + epsilon);
            tt = t + h;
        end
        
        function [x, q, dx] = getLastX_Q_dX(obj)
            x = transpose(obj.trajectory(end, :));
            q = transpose(obj.q_trajectory(end, :));
            dx = transpose(obj.dx_trajectory(end, :));
        end
        
        function tt = getNextTime2(obj, i, x, q, t)
            deltaQ = obj.q(i);
            xi = x(i);
            qi = q(i);
            dxi = obj.diffi(i, q);
            
            if dxi > 0
                h = (qi - xi + deltaQ)/(dxi);
            else
                if dxi < 0
                    h = (qi - xi - deltaQ)/(dxi);
                else
                    h = obj.maxTime;
                end
            end
            tt = t + h;
        end
        
        function dxi = diffi(obj, i, x)
            dx = obj.A * x;
            dxi = dx(i);
        end
        
        function [x] = getTrajectory(obj)
            x = obj.q_trajectory(2:end, :);
        end
        
        function [t] = getSimulationTimeVector(obj)
            t = obj.time_vector;
        end
        
        function t = getLastTimeComputed(obj)
            t = obj.time_vector(end);
        end
        
        function obj = setMaxTime(obj, t)
            obj.maxTime = t;
        end
    end
end

