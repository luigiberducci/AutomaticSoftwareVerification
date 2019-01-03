classdef InverseCubicPoly < root.RootSolver
    % INVERSECUBICPOLY Implementation of inverse cubic polynomial interpolation for 
    % finding a root of the equation f(x)=0 in a given interval [a,b].
    properties
        dfdt;   %First order derivative of `f`
    end
    
    methods
        function obj = InverseCubicPoly(f, df, a, b, tol)
            % INVERSECUBICPOLY Construct an instance of ICP method.
            %    It is a "single-step" algorithm, then it has no sense to 
            %    invoke it multiple times BUT since we tried to implement a
            %    generic "root-solver" abstraction, then it has such methods.
            %
            %    We assume to know the value of `f` and `df` at `a` and
            %    `b`. Try to interpolate with an INVERSE cubic polynomial
            %    which gives us `t` since its dependent variable is the
            %    time.
            obj = obj@root.RootSolver(f, a, b, tol);
            obj.dfdt = df;
        end
        
        function obj = nextIteration(obj)
            % NEXTITERATION Compute the unique iteration of cubic interpolation.
            %    Ensure that the points f(a), f(b) have opposite signs,
            %    otherwise the method cannot ensure the existance of a
            %    root. Then, find the root of line passing through both
            %    points and restrict the interval.
            
            % Map to simulator nomenclature
            t_k  = obj.a;
            t_k1 = obj.b;
            f_k  = obj.f(t_k);
            f_k1 = obj.f(t_k1);
            u_k  = inv(obj.dfdt(t_k));  % u_k = dt(f_k)/df = 1/(df(tk)/dt) 
            u_k1 = inv(obj.dfdt(t_k1)); % As the line above
            if f_k*f_k1>0
                warning("The points f(a)=%d and f(b)=%d have same sign.", fa, fb);
                return;
            end
            
            % Defines equations for interpolation
            syms a b c d;    % Symbolic uknowns
            t  = @(p) a*(p^3) + b*(p^2) + c*p + d;
            dt = @(p) 3*a*(p^2) + 2*b*p + c;
            
            t_fk   = t(f_k)   == t_k;
            t_fk1  = t(f_k1)  == t_k1;
            dt_fk  = dt(f_k)  == u_k;
            dt_fk1 = dt(f_k1) == u_k1;

            coeffsPoly3 = solve(t_fk, t_fk1, dt_fk, dt_fk1);
            
            % Given the inverse polynomial, t_next = t(p=0) = d
            zero = coeffsPoly3.d;
            
            % Update history and increment number of iterations
            obj.history(end+1) = zero;
            obj.iters = obj.iters + 1;
        end       
        
        function ans = isOutOfInterval(obj, x)
            %ISOUTOFINTERVAL Check if the point `x` is out of the interval [`a`, `b`].
            ans = false;
            if x<obj.a || x>obj.b
                ans = true;
            end
        end    
        
        function ans = isConverged(obj)
            %ISCONVERGED Return a boolean answer about convergence of
            %method with respect to the tolerance value defined.
            %   
            % Returns:
            % --------
            %    -`ans` boolean defined as `true` if the method converged
            %    with respect to the tolerance error, `false` otherwise.
            ans = false;
            if size(obj.history,1)>0
                lastValue = obj.f(obj.history(end));
                if abs(lastValue)<obj.tol
                    ans = true;
                end
            end
        end
        
        function plot(obj)
            % PLOT Plot the function in the given interval and highlight
            % the single point computed as root of IP3.
            
            % Define the most significant range
            lo = obj.a;
            hi = obj.b;
            step = (hi-lo)/1000;
            range = [lo : step : hi];

            % Plot the function F in the range
            f_range = arrayfun(obj.f, range);
            plot(range, f_range);
            hold on;
            title("Inverse cubic polynomial");
            
            % Plot the points obtained by iterations
            for i = 1:size(obj.history, 1)
                x = obj.history(i);
                fx = obj.f(x);
                
                plot(x, fx, 'o', ...  % The last one is marked with *
                            'MarkerSize', 10, ...
                            'MarkerFaceColor', [1 0 0]);
            end
        end
    end
end

