classdef RootSolver
    %% ROOTSOLVER Interface for generic root solver of equation f(x)=0
    % Any root solver has the following attribute:
    %    -`f` the function that we want to solve, finding the root.
    %    -[`a`,`b`] the closed interval in which we want to find the root.
    %    -`tol` the error tolerance for root because the result is an
    %    approximation and not an exact analytical result.
    % Finally, since we are interested on the execution of the method, we
    % introduce the following attributes:
    %    - `iters` the number of iterations used by the method to converge
    %    - `history` the collection of intermediate results computed by the
    %    method, such as intermediate points and so on.
    
    properties
        f       % Function of which we want the root
        a       % Lowerbound of interval
        b       % Upperbound of interval
        iters   % The number of iterations needed to converge
        history % Collection of intermediate results
        tol     % Error tolerance of method
    end
    
    methods (Abstract)
        nextIteration(obj)      % Compute the next iteration
        isConverged(obj)        % Return true if the method converged
        plot(obj)               % Plot a graphical representation of iterations computed
    end
    
    methods
        function obj = RootSolver(f, a, b, tol)
            %ROOTSOLVER Construct an instance of this class
            %
            % Parameters:
            % -----------
            %    -`f` function which we want to solve
            %    -`a`, `b` delimit the interval in which find the root
            %    -`tol` is the tolerance error
            obj.f = f;
            obj.a = a;
            obj.b = b;
            obj.tol     = tol;
            obj.iters   = 0;
            obj.history = [];
        end
    end
end

