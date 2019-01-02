classdef RegulaFalsi < root.RootSolver
    % REGULAFALSI Implementation of Regula Falsi for finding a root of the
    % equation f(x)=0 in a given interval [a,b].
    methods
        function obj = RegulaFalsi(f, a, b, tol)
            %% REGULAFALSI Construct an instance of Regula Falsi method.
            obj = obj@root.RootSolver(f, a, b, tol);
            obj.history(1, :) = [obj.a obj.b];
        end
        function obj = nextIteration(obj)
            % NEXTITERATION Compute the next iteration of RegulaFalsi.
            %    Ensure that the points f(a), f(b) have opposite signs,
            %    otherwise the method cannot ensure the existance of a
            %    root. Then, find the root of line passing through both
            %    points and restrict the interval.
            fa = obj.f(obj.a);
            fb = obj.f(obj.b);
            if fa*fb>0
                warning("The points f(a)=%d and f(b)=%d have same sign.", fa, fb);
                return;
            end
            
            % Compute coeffs of the line passing through `fa` and `fb`
            % and the value of the line root. Since a line is defined as
            % l = mx + q, then l=0 in x=-m/q.
            lineCoeffs = polyfit([obj.a obj.b], [fa fb], 1);
            zero = -lineCoeffs(2)/lineCoeffs(1);
            
            % Make smaller the interval according to the sign of the zero
            fZero = obj.f(zero);
            if fZero*fa > 0
                obj.a = zero;
            else
                obj.b = zero;
            end

            % Update history and increment number of iterations
            obj.history(end+1, :) = [obj.a obj.b];
            obj.iters = obj.iters + 1;
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
            if abs(lastValue)<obj.tol
                ans = true;
            end
        end
        
        function plot(obj)
            % PLOT Plot the function in the given interval and highlight
            % the points corresponding to RF iterations.
            
            % Define the most significant range
            lo = obj.history(1, 1);
            hi = obj.history(1, 2);
            step = (hi-lo)/1000;
            range = [lo:step:hi];

            % Plot the function F in the range
            f_range = arrayfun(obj.f, range);
            plot(range, f_range);
            hold on;
            title("Regula Falsi");
            
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

