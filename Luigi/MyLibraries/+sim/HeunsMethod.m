classdef HeunsMethod < sim.Simulator
    %% HEUNSMETHODS Simulator based on Pred/Corr integration method.
    %  Predictor: x_p(k+1) = x(k) + h*(dx(k)/dt) = (I+Ah)x(k)
    %  Corrector: x_c(k+1) = x(k) + 0.5*h(dx(k) + dx_p(k+1)/dt)
    methods
        function obj = HeunsMethod(h, A, x0)
            %% HEUNSMETHOD Construct an instance of HM simulator (it is RK2)
            obj = obj@sim.Simulator(h, A, x0);
        end
        function obj = step(obj)
            %% STEP Go ahed the simulation of 1 step.
            x_k = transpose(obj.trajectory(end, :));

            x_p_k1 = (eye(size(obj.A)) + obj.h*obj.A)*x_k;             % FE Predictor
            x_k1   = x_k + obj.h*0.5*((obj.A*x_k) + (obj.A*x_p_k1));  % BE Corrector
            % Append next state to trajectory and increment steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end
