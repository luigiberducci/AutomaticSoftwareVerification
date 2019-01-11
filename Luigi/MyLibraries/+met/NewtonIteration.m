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
        F       % Symbolic function
        H       % Symbolic Hessian matrix (TODO: remove it)
        x0      % Initial attempt, starting point for NI
        x       % Vector containing NI values
        f_x     % Evaluation vector containing the value of F in x
        tol     % Error tolerance for convergence
    end
    
    methods
        function obj = NewtonIteration(F, x0, varargin)
            % NEWTONITERATION Construct an instance of NI
            %   
            % Parameters:
            % -----------
            %   `F`   symbolic function representing the zero-function to solve
            %   `x0`  initial attempt from which start the NI
            %   `tol` convergence tolerance (optional)
            obj.F   = F;
            obj.H = jacobian(F, symvar(F));
            obj.x0  = x0;
            obj.x(1,:) = x0;
            obj.f_x(1, :) = double(subs(F, symvar(F), x0'));
            
            if size(varargin, 2)>0
                obj.tol = varargin{1};
            else
                obj.tol = 10^-3;
            end
        end
        
        function obj = run(obj)
            % RUN Execute Newton Iteration until convergence according to
            % the tolerance defined in `obj.tol`.
            while not(obj.isConverged())
                obj = obj.next();
            end
        end
        
        function obj = next(obj)
            % NEXT Run the next NI iteration
            %     It extend the attempts x with a new element defined as
            %     follow:
            %     x_l+1 = x_l - inv(H)*F,     where H,F are computed in x_l
            x_l  = obj.x(end, :);
            F_l = double(subs(obj.F, symvar(obj.F), x_l));
            H_l = double(subs(obj.H, symvar(obj.F), x_l));
            x_l1 = x_l' - inv(H_l)*F_l;
            f_x_l1 = double(subs(obj.F, symvar(obj.F), x_l1'));
            
            
            obj.x(end+1, :)   = x_l1;
            obj.f_x(end+1, :) = f_x_l1;
        end
        
        function answ = isConverged(obj)
            answ = false;
            err = obj.getConvergenceError();
            if err <= obj.tol
                answ = true;
            end
        end
        
        function [err] = getConvergenceError(obj)
            err = Inf;
            if size(obj.f_x,1) >=2
                last1 = abs(obj.f_x(end));
                last2 = abs(obj.f_x(end-1));
                err = abs(last1-last2);
            end
        end
        
        function x = getLastValue(obj)
            x = obj.x(end, :);
        end
        
        function plot(obj, varargin)
            % PLOT Plot the function in the most significant range and the
            % points corresponding to NI attempt. The most significant
            % range is computed to contain all the attempts and discretized 
            % in 1000 points.
            
            % Define the most significant range
            if size(varargin, 2) > 0
                lo = varargin{1};
                hi = varargin{2};
            else
                lo = min(obj.x);
                hi = max(obj.x);
            end
            step = (hi-lo)/1000;
            range = [];
            for i = 1:size(obj.x0, 1)
                range = [range; lo:step:hi];
            end
            range = transpose(range);
            % Plot the function F in the range
            f_range = [];
            for i = 1:size(range, 1)
                i_res = double(subs(obj.F, symvar(obj.F), range(i,:)));
                f_range = [f_range; i_res'];
            end
            
            for i = 1:size(obj.x0, 1)
                plot(range(:, i), f_range(:, i));
                hold on;
            end
            title("Newton Iteration result");
            
            % Plot the points obtained by NI
            for i = 1:size(obj.x, 1)
                xx = obj.x(i, :);
                yy = obj.f_x(i, :);
                
                if i == size(obj.x, 1)
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

