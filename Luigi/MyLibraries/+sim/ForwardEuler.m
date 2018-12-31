classdef ForwardEuler < sim.Simulator
    %% FORWARDEULER Simulator based on FE integration method.
    %  x(k+1) = x(k) + h*(d(x(k))/dt) = (I+Ah)x(k)
    methods
        function obj = ForwardEuler(h, A, x0)
            %% FORWARDEULER Construct an instance of FE simulator
            obj = obj@sim.Simulator(h, A, x0);
        end
        function obj = step(obj)
            %% STEP Go ahed the simulation of 1 step.
            x_k = transpose(obj.trajectory(end, :));

            x_k1 = (eye(size(obj.A)) + obj.h*obj.A)*x_k;  % Compute next state
            % Append next state to trajectory and increment steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end

