classdef SimulatorFactory
    %SIMULATORFACTORY Manage the simulation
    %   Allow to create a simulator, simulate for a time interval and plot
    %   the results.
    
    properties
        sim         %Simulator object
        anl         %Analytical system
        currTime    %Current time
    end
    
    methods
        function obj = SimulatorFactory(algo, A, h, x0)
            %SIMULATORFACTORY Construct an instance of this class
            %   Detailed explanation goes here
            B = zeros(size(A, 1), 1);
            C = eye(size(A));
            D = zeros(size(A, 1), 1);
            obj.anl = ss(A, B, C, D);
            switch algo
                case "FE"
                    obj.sim = sim.ForwardEuler(h, A, x0);
                case "BE"
                    obj.sim = sim.BackwardEuler(h, A, x0);
                case "PC"
                    obj.sim = sim.PredictorCorrector(h, A, x0);
                case "HE"
                    obj.sim = sim.HeunsMethod(h, A, x0);
                case "EMR"
                    obj.sim = sim.ExplicitMidpointRule(h, A, x0);
                case "RK2"
                    obj.sim = sim.RK2(h, A, x0);
                case "RK4"
                    obj.sim = sim.RK4(h, A, x0);
                case "BDF1"
                    obj.sim = sim.BDF(h, A, x0, 1, true);
                case "BDF2"
                    obj.sim = sim.BDF(h, A, x0, 2, true);
                case "BDF3"
                    obj.sim = sim.BDF(h, A, x0, 3, true);
                case "BDF4"
                    obj.sim = sim.BDF(h, A, x0, 4, true);
                case "BDF5"
                    obj.sim = sim.BDF(h, A, x0, 5, true);
                case "BDF6"
                    obj.sim = sim.BDF(h, A, x0, 6, true);
                otherwise
                    error("The integration method %s isn't implemented.", algo);
            end
            obj.currTime = -1;
        end
        
        function obj = simulate(obj, t0, tf)
            %SIMULATE Run simulation in the interval [t0, tf] with step `h`
            if not(obj.currTime==-1)
                warning("There is a stored simulation, reset the simulation to run again.");
                return;
            end    
            
            if t0<0 || tf<t0
                error("Time interval not valid [%f,%f]", t0, tf);
            end
            
            time = obj.getTimeVector(t0, tf);
            
            for i=1:size(time,2)-1
                obj.sim = obj.sim.step();
            end
            
            obj.plot(t0, tf);
        end
        
        function [time] = getTimeVector(obj, t0, tf)
            time = t0:obj.sim.h:tf;
        end
        
        function plot(obj, t0, tf)
            x_sim = obj.sim.getTrajectory();
            x_anl = obj.simulateAnalytical(t0, tf);
            time = obj.getTimeVector(t0, tf);
            subplot(1, 2, 1);
            plot(time, x_sim);
            title("Simulated trajectory");
            
            subplot(1, 2, 2);
            plot(time, x_anl);
            title("Analytical trajectory");
        end
        
        function [x] = simulateAnalytical(obj, t0, tf)
            x0 = obj.sim.x0;
            A = obj.sim.A;
            B = zeros(size(A,1),1);
            C = eye(size(A));
            D = zeros(size(A,1),1);
            sys = ss(A,B,C,D, obj.sim.h);
            time = obj.getTimeVector(t0, tf);
            u = zeros(size(time));
            [y, t, x] = lsim(sys, u, time, x0);
        end
    end
    
    
        
end

