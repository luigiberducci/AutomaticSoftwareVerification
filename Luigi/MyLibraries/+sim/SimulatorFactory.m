classdef SimulatorFactory
    %SIMULATORFACTORY Manage the simulation
    %   Allow to create a simulator, simulate for a time interval and plot
    %   the results.
    
    properties
        name        %Integration method name
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
                    obj.name = "FE";
                    obj.sim = sim.ForwardEuler(h, A, x0);
                case "BE"
                    obj.name = "BE";
                    obj.sim = sim.BackwardEuler(h, A, x0);
                case "PC"
                    obj.name = "PC";
                    obj.sim = sim.PredictorCorrector(h, A, x0);
                case "HE"
                    obj.name = "HE";
                    obj.sim = sim.HeunsMethod(h, A, x0);
                case "EMR"
                    obj.name = "EMR";
                    obj.sim = sim.ExplicitMidpointRule(h, A, x0);
                case "RK2"
                    obj.name = "RK2";
                    obj.sim = sim.RK2(h, A, x0);
                case "RK4"
                    obj.name = "RK4";
                    obj.sim = sim.RK4(h, A, x0);
                case "BDF1"
                    obj.name = "BDF1";
                    obj.sim = sim.BDF(h, A, x0, 1, true);
                case "BDF2"
                    obj.name = "BDF2";
                    obj.sim = sim.BDF(h, A, x0, 2, true);
                case "BDF3"
                    obj.name = "BDF3";
                    obj.sim = sim.BDF(h, A, x0, 3, true);
                case "BDF4"
                    obj.name = "BDF4";
                    obj.sim = sim.BDF(h, A, x0, 4, true);
                case "BDF5"
                    obj.name = "BDF5";
                    obj.sim = sim.BDF(h, A, x0, 5, true);
                case "BDF6"
                    obj.name = "BDF6";
                    obj.sim = sim.BDF(h, A, x0, 6, true);
                case "QSS"
                    obj.name = "QSS";
                    q = h;
                    obj.sim = sim.QSS(q, A, x0);
                otherwise
                    error("The integration method %s isn't implemented.", algo);
            end
            obj.currTime = -1;
        end
        
        function [t, x] = getSimulatedResult(obj, t0, tf)
            tmp_obj = obj.simulate(t0, tf);
            if tmp_obj.isStateQuantizing()
                x = tmp_obj.sim.getTrajectory();
                t = tmp_obj.sim.getSimulationTimeVector();
            else
                x = tmp_obj.sim.getTrajectory();
                t = tmp_obj.getTimeVector(t0, tf);
            end
        end
        
        function [t, x] = getAnalyticalResult(obj, t0, tf)
            x = obj.simulateAnalytical(t0, tf);
            t = obj.getTimeVector(t0, tf);
        end
        
        function obj = simulate(obj, t0, tf)
            %SIMULATE Run simulation in the interval [t0, tf] with step `h`
            if not(obj.currTime==-1)
                warning("There is a stored simulation, reset the simulation to run again.");
                return;
            end    
            
            if obj.timeRangeNotValid(t0, tf);
                error("Time range not valid [%f,%f]", t0, tf);
            end
            
            time = obj.getTimeVector(t0, tf);
            
            if obj.isStateQuantizing()
                t = t0;
                %obj.sim = obj.sim.setMaxTime(tf);
                while t<tf
                    obj.sim = obj.sim.step();
                    t = obj.sim.getLastTimeComputed();
                end
                obj.plotQSS(t0, tf);
            else
                for i=1:size(time,2)-1
                    obj.sim = obj.sim.step();
                end
                obj.plot(t0, tf);
            end
        end
        
        function ans = isStateQuantizing(obj)
            ans = obj.name == "QSS";
        end
        
        function ans = timeRangeNotValid(obj, t0, tf)
            ans = t0<0 || tf<t0;
        end
        
        function [time] = getTimeVector(obj, t0, tf)
            h = obj.sim.h;
            if h==0
                h = 1e-1;
            end
            time = t0:h:tf;
        end
        
        function plot(obj, t0, tf)
            x_sim = obj.sim.getTrajectory();
            x_anl = obj.simulateAnalytical(t0, tf);
            time = obj.getTimeVector(t0, tf);
            subplot(1, 2, 1);
            plot(time, x_sim);
            title("Simulated trajectory");
            legend();
            
            subplot(1, 2, 2);
            plot(time, x_anl);
            title("Analytical trajectory");
            legend();
            
            obj.printSimulationInfo();
        end
        
        function plotQSS(obj, t0, tf)
            x_sim = obj.sim.getTrajectory();
            qssTime = obj.sim.getSimulationTimeVector();
            
            x_anl = obj.simulateAnalytical(t0, tf);
            time = obj.getTimeVector(t0, tf);
            
            subplot(1, 2, 1);
            plot(qssTime, x_sim);
            title("Simulated trajectory");
            legend();
            
            subplot(1, 2, 2);
            plot(time, x_anl);
            title("Analytical trajectory");
            legend();
            
            obj.printSimulationInfo();
        end
        
        function printSimulationInfo(obj)
            fprintf("Integration method: %s\n", obj.name);
            fprintf("Number of steps: %d\n", obj.sim.numberOfSteps);
        end
        
        function [x] = simulateAnalytical(obj, t0, tf)
            x0 = obj.sim.x0;
            A = obj.sim.A;
            
            time = obj.getTimeVector(t0, tf);
            x = zeros(size(time, 2), size(x0, 1));
            for k=1:size(time, 2)
                t = time(k);
                x(k, :) = expm(A*t)*x0;
            end
        end
    end
end

