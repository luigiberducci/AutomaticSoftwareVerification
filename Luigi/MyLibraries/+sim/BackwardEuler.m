classdef BackwardEuler < sim.Simulator
    %% BACKWARDEULER Simulator based on FE integration method.
    %  x(k+1) = x(k) + h*(d(x(k+1))/dt) = inv(I-hA)*(x(k)
    methods
        function obj = BackwardEuler(h, A, x0)
            %% FORWARDEULER Constructor of object FE.
            obj.trajectory(1,:) = x0;
            obj.numberOfSteps = 0;
            obj.h  = h;
            obj.x0 = x0;
            obj.A  = A;
        end
        function obj = step(obj)
            %% STEP Go ahed the simulation of 1 step.
            x_k = transpose(obj.trajectory(end, :));

            F = inv(eye(size(obj.A)) - obj.h*obj.A);
            x_k1 = F*x_k;       % Compute next state
            % Append next state and increment steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end

