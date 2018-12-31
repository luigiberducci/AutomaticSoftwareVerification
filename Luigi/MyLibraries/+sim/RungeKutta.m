classdef RungeKutta < sim.Simulator
    %RUNGEKUTTA Abstract class for RK family
    %   It works for generic Alpha, Bheta matrices
    %   and compute the next step according to them.
    
    % Abstract representation
    properties
        Alpha    % Alpha defines the evaluation time instant
        Beta     % Beta defines the weights of previous derivative (stage)
    end
    
    methods
        function obj = step(obj)
            %STEP The simulation goes 1 step ahed
            x_k = transpose(obj.trajectory(end, :));
            
            % Initialize stage variables for state and derivative
            x_p   = zeros(size(x_k, 1), size(obj.Alpha, 1));
            d_x_p = zeros(size(x_k, 1), size(obj.Alpha, 1));
            
            % Set the first derivative as dx = A*x
            d_x_p(:, 1) = obj.A*x_k;
            
            % Loop over the stages
            for stage = 1:size(obj.Alpha, 1)
                % Compute the sum of product beta*derivatives
                % x_p = x_k + h*sum_{i:1,stage}(beta(stage,i)*d_x_p(i))
                tmp = 0;
                for i = 1:stage
                    tmp = tmp + obj.Beta(stage, i)*d_x_p(:, i);
                end
                % Compute the state x_p
                x_p(:, stage) = x_k + obj.h*tmp;
                
                % The derivative should be computed at time indicated by
                % Alpha but since there is no input, it doesn't change
                d_x_p(:, stage+1) = obj.A* x_p(:, stage);
            end
            
            % The last stage (corrector) state is the next state
            x_k1 = x_p(:, end);
            
            % Append next state to trajectory and increment steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end

