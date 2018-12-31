classdef ExplicitMidpointRule < sim.Simulator
    %% EXPLICIT MIDPOINT RULE Simulator based on RK2 method.
    %  Predictor: x_p(k+1/2) = x(k) + h/2*(dx(k)/dt)
    %  Corrector: x_c(k+1)   = x(k) + h(dx_p(k+1/2)/dt)
    methods
        function obj = ExplicitMidpointRule(h, A, x0)
            %% FORWARDEULER Construct an instance of EMR simulator (it is RK2)
            obj = obj@sim.Simulator(h, A, x0);
        end
        function obj = step(obj)
            %% STEP Go ahed the simulation of 1 step.
            x_k = transpose(obj.trajectory(end, :));

            % Predictor
            dx_k = obj.A*x_k;
            px_k12 = x_k + obj.h/2 * dx_k;

            % Corrector
            dpx_k12 = obj.A*px_k12;
            x_k1 = x_k + obj.h*dpx_k12;
            
            % Append next state to trajectory and increment steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end

