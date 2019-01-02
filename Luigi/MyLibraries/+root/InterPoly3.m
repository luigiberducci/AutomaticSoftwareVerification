classdef InterPoly3 < root.RootSolver
    % INTERPOLY3 Implementation of cubic polynomial interpolation for 
    % finding a root of the equation f(x)=0 in a given interval [a,b].
    properties
        dfdt;   %First order derivative of `f`
    end
    
    methods
        function obj = InterPoly3(f, df, a, b, tol)
            % INTERPOLY3 Construct an instance of IP3 method.
            %    It is a "single-step" algorithm, then it has no sense to 
            %    invoke it multiple times BUT since we tried to implement a
            %    generic "root-solver" abstraction, then it has such methods.
            %
            %    We assume to know the value of `f` and `df` at `a` and
            %    `b`. Try to interpolate with a cubic polynomial and once
            %    known the coefficent of such polynomial p, find its roots.
            %    Notice that they could be potentially 3 different solutions.
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
            t_k = obj.a;
            t_k1 = obj.b;
            f_k = obj.f(t_k);       % Eval function at time t(k)
            f_k1 = obj.f(t_k1);     % Eval function at time t(k+1)
            df_k = obj.dfdt(t_k);   % Eval 1st derivative at t(k)
            df_k1 = obj.dfdt(t_k1); % Eval 1st derivative at t(k+1)
            if f_k*f_k1>0
                warning("The points f(a)=%d and f(b)=%d have same sign.", fa, fb);
                return;
            end
            
            % Defines equations for interpolation
            syms a b c d;    % Symbolic uknowns
            p  = @(t) a*(t^3) + b*(t^2) + c*t + d;
            dp = @(t) 3*a*(t^2) + 2*b*t + c;
            
            p_tk   = p(t_k)   == f_k;
            p_tk1  = p(t_k1)  == f_k1;
            dp_tk  = dp(t_k)  == df_k;
            dp_tk1 = dp(t_k1) == df_k1;

            coeffsPoly3 = solve(p_tk, p_tk1, dp_tk, dp_tk1);
            
            % Define equation for root finding
            zero = roots([coeffsPoly3.a, coeffsPoly3.b, coeffsPoly3.c, coeffsPoly3.d]);
            
            % Update history and increment number of iterations
            for r = 1:size(zero,1)
                if obj.isOutOfInterval(zero(r))==false
                    obj.history(end+1) = zero(r);
                    break;
                end
            end
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
            title("Cubic polynomial interpolation");
            
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

