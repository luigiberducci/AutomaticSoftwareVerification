classdef NewtonIteration
    % NEWTONITERATION Implementation of Newton method (NI) to solve
    % zero-functions. The iterative approach is defined starting from an
    % initial attempt x_l, as follow:
    %           x_l+1 = x_l - F/(dF/dx)
    % where F is the zero-function that we want to solve and dF/dx is the
    % partial derivative. Since F is taken from the state-space model, it
    % is basically a function w.r.t. x, dx, t. Then dF/dx is the derivative
    % of a differential equation. For this reason, we call it H (Hessian).
    %
    % Notice that it works with F, H `func` then it doesn't work for
    % state-space model representation with matrices.
    properties
        F       % Zero-function to solve
        H       % Hessian defined as dF/dx
        x0      % Initial attempt, starting point for NI
        x       % Vector containing NI values
        f_x     % Evaluation vector containing the value of F in x
    end
    
    methods
        function obj = NewtonIteration(F, H, x0)
            % NEWTONITERATION Construct an instance of NI
            %   
            % Parameters:
            % -----------
            %   `F`   func representing the zero-function to solve
            %   `H`   func representing the Hessian of F defined as dF/dx
            %   `x0`  initial attempt from which start the NI
            obj.F   = F;
            obj.H   = H;
            obj.x0  = x0;
            obj.x   = [x0];
            obj.f_x = [F(x0)];
        end
        
        function obj = next(obj)
            % NEXT Run the next NI iteration
            %     It extend the attempts x with a new element defined as
            %     follow:
            %     x_l+1 = x_l - inv(H)*F,     where H,F are computed in x_l
            x_l  = obj.x(end);
            x_l1 = x_l - inv(obj.H(x_l))*obj.F(x_l);
            
            obj.x(end+1)   = x_l1;
            obj.f_x(end+1) = obj.F(x_l1);
        end
        
        function plot(obj)
            % PLOT Plot the function in the most significant range and the
            % points corresponding to NI attempt. The most significant
            % range is computed to contain all the attempts and discretized 
            % in 1000 points.
            
            % Define the most significant range
            lo = min(obj.x);
            hi = max(obj.x);
            step = (hi-lo)/1000;
            range = [lo:step:hi];

            % Plot the function F in the range
            f_range = arrayfun(obj.F, range);
            plot(range, f_range);
            hold on;
            title("Newton Iteration result");
            
            % Plot the points obtained by NI
            for i = 1:size(obj.x, 2)
                xx = obj.x(i);
                yy = obj.f_x(i);
                
                if i == size(obj.x, 2)
                    plot(xx, yy, 'o', ...  % The last one is marked with *
                                 'MarkerSize', 10, ...
                                 'MarkerFaceColor', [1 0 0]);
                else
                    plot(xx, yy, 'o');  % The other ones are marked with o
                end
            end
        end
    end
end

