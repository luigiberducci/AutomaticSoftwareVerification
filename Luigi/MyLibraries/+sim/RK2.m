classdef RK2 < sim.RungeKutta
    %RK2 Implementation of family Runge-Kutta 2
    %    This class implements the abstract class RungeKutta, then varying 
    %    the matrices Alpha and Beta, you can implement other RK2 algorithm.
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
        function obj = RK2(h, A, x0)
            %RK2 Construct an instance of this class
            %    The current implementation is also called Heun's
           
            % Invoke the superclass' constructor
            obj = obj@sim.RungeKutta(h, A, x0);
            
            % Define Alpha, Beta specific for this algorithm
            obj.Alpha = [1; 1];
            obj.Beta  = [  1,   0;
                         1/2, 1/2];
        end
    end
end

