classdef RK4 < sim.RungeKutta
    %RK4 Implementation of family Runge-Kutta 4
    %    This class implements the abstract class RungeKutta, then varying 
    %    the matrices Alpha and Beta, you can implement other RK4 algorithm.
    %    
    %    Parameters:
    %    -----------
    %       Alpha, Beta:    Alpha defines the evaluation time instant,
    %                       instead Beta defines the weight factors of
    %                       previous derivative.
    %       A:              system dynamics (dx=A*x).
    %       h:              integration step.
    %       x0:             initial state of the system.  
    methods
        function obj = RK4(h, A, x0)
            %RK2 Construct an instance of this class
            %    The current implementation is the well-known RK4 taken
            %    from the book (page 79).
            obj.Alpha = [1/2; 1/2; 1; 1];
            obj.Beta  = [1/2,   0,   0,   0;
                           0, 1/2,   0,   0;
                           0,   0,   1,   0;
                         1/6, 1/3, 1/3, 1/6];
            obj.trajectory(1,:) = x0;
            obj.numberOfSteps = 0;
            obj.h  = h;
            obj.x0 = x0;
            obj.A  = A;
        end
    end
end
