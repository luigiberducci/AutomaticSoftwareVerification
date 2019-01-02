classdef NewtonIteration < root.RootSolver
    % NEWTONITERATION Implementation of NewtonIteration for finding a root of the
    % equation f(x)=0 in a given interval [a,b].
    properties
        dfdt                % First order derivative of `f`
        solvIssue = false;  % True if NI cannot converge
    end
    
    methods
        function obj = NewtonIteration(f, df, a, b, tol)
            % NEWTONITERATION Construct an instance of NI method.
            obj = obj@root.RootSolver(f, a, b, tol);
            obj.history(1, :) = [obj.a obj.b];
            obj.dfdt = df;
        end
        function obj = nextIteration(obj)
            % NEXTITERATION Compute the next iteration of NI.
            %    Compute next point starting from `a`. If it
            %    fails because goes out of interval, try backward starting
            %    from `b`.
            x_l = obj.a;
            x_l1 = x_l - obj.f(x_l)/obj.dfdt(x_l);

            if obj.isOutOfInterval(x_l1)    % Try again starting from `b`
                fprintf("[Info] Iter %d: %d out of interval from `a`\n", obj.iters+1, x_l1);
                x_l = obj.b;
                x_l1 = x_l - inv(obj.dfdt(x_l)) * obj.f(x_l);
                if obj.isOutOfInterval(x_l1) % NI cannot converge
                    warning("NI cannot converge\n");
                    obj.solvIssue = true;
                else
                    obj.b = x_l1;
                end
            else
                obj.a = x_l1;
            end
                
            % Update history and increment number of iterations
            obj.history(end+1, :) = [obj.a obj.b];
            obj.iters = obj.iters + 1;
        end       
        
        function ans = isOutOfInterval(obj, x)
            %ISOUTOFINTERVAL Check if the point `x` is out of the interval [`a`, `b`].
            ans = false;
            a = obj.history(1,1);   % Original interval lowerbound
            b = obj.history(1,2);   % Original interval upperbound
            if x<a || x>b
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
            lastValue = min( abs(obj.f(obj.history(end,1))), ... 
                             abs(obj.f(obj.history(end,2))));
            if abs(lastValue)<obj.tol || obj.solvIssue == true
                ans = true;
            end
        end
        
        function plot(obj)
            % PLOT Plot the function in the given interval and highlight
            % the points corresponding to NI iterations.
            
            % Define the most significant range
            lo = obj.history(1, 1);
            hi = obj.history(1, 2);
            step = (hi-lo)/1000;
            range = [lo:step:hi];

            % Plot the function F in the range
            f_range = arrayfun(obj.f, range);
            plot(range, f_range);
            hold on;
            title("Newton Iteration");
            
            % Plot the points obtained by iterations
            for i = 1:size(obj.history, 1)
                a = obj.history(i, 1);
                b = obj.history(i, 2);
                fa = obj.f(a);
                fb = obj.f(b);
                
                if i == size(obj.history, 1)
                    plot(a, fa, 'o', ...  % The last one is marked with *
                                 'MarkerSize', 10, ...
                                 'MarkerFaceColor', [1 0 0]);
                    plot(b, fb, 'o', ...  % The last one is marked with *
                                 'MarkerSize', 10, ...
                                 'MarkerFaceColor', [1 0 0]);
                else
                    plot(a, fa, 'o');  % The other ones are marked with o
                    plot(b, fb, 'o');  % The other ones are marked with o
                end
            end
        end
    end
end

