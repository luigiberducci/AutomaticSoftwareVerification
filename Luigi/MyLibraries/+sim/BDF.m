classdef BDF < sim.Simulator
    %BDF Abstract class for generic Backward Difference Formulae
    %    This implementation contains the matrices which define
    %    the BDF methods of any order between 1 and 5.
    
    properties
        order                   % Order of the BDF method in [1,5]
        futureDerivativeCoeff   % Coefficent of d(x_k+1)/dt in BDF step
        pastStateCoeffs         % Coefficents of previous state x_k, x_k-1, ..
    end
    
    methods
        function obj = BDF(h, A, x0, order)
            %BDF Construct an instance of this class
            %   Detailed explanation goes here
            
            % Invoke the superclass' constructor
            obj = obj@sim.Simulator(h, A, x0);
            
            % Define the matrices for BDF algorithms and the desired order
            obj.futureDerivativeCoeff = [1; 2/3; 6/11; 12/25; 60/137; 60/147];
            obj.pastStateCoeffs = [       1,        0,       0,        0,      0,       0;
                                        4/3,     -1/3,       0,        0,      0,       0;
                                      18/11,    -9/11,    2/11,        0,      0,       0;
                                      48/25,   -36/25,   16/25,    -3/25,      0,       0;
                                    300/137, -300/137, 200/137,  -75/137, 12/137,       0;
                                    360/147, -450/147, 400/147, -225/147, 72/147, -10/147];
            obj.order = order;
        end
        
        function obj = step(obj)
            %STEP  Run the simulation one step ahed
            %      Until reach the number of previous state needed, 
            %      it uses a lower order BDF method.
            
            % Initialize the buffer of previous state as 0-states
            bufferOfStates = zeros(size(obj.futureDerivativeCoeff,1), size(obj.A,1));
            if size(obj.trajectory, 1) < obj.order
                for i = 1:size(obj.trajectory, 1)   % Fill with the available states
                    bufferOfStates(i, :) = obj.trajectory((end-i+1), :);                    
                end
                currentOrder = size(obj.trajectory, 1);
            else
                % Fetch the last `order` states    
                for i = 1:obj.order
                    bufferOfStates(i, :) = obj.trajectory((end-i+1), :);
                end
                currentOrder = obj.order;
            end
            
            % Pick the coefficent related to the order choosen
            currFutureCoeff = obj.futureDerivativeCoeff(currentOrder);
            currPastCoeffs  = obj.pastStateCoeffs(currentOrder, :);
            I = eye(size(obj.A));
            
            % Rather than comput inv(I-k*h*A)*(previous states), MATLAB
            % suggested to use division for efficiency/accuracy purposes
            % The theoretical implementation is the following:
            % x_k+1 = inv(I-currFutureCoeff*h*A) * 
            %         (pastCoeff(1)*x_k + pastCoeff(2)*x_k-1 + ... 
            %         + pastCoeff(5)*x_k-5)
            x_k1 = (I - currFutureCoeff * obj.h * obj.A) \ ( ...
                   currPastCoeffs(1)*transpose(bufferOfStates(1,:)) + ...
                   currPastCoeffs(2)*transpose(bufferOfStates(2,:)) + ...
                   currPastCoeffs(3)*transpose(bufferOfStates(3,:)) + ...
                   currPastCoeffs(4)*transpose(bufferOfStates(4,:)) + ...
                   currPastCoeffs(5)*transpose(bufferOfStates(5,:)) + ...
                   currPastCoeffs(6)*transpose(bufferOfStates(6,:)) );
            
            % Add the new state to trajectory, increment the steps counter
            obj.trajectory(end+1, :) = x_k1;
            obj.numberOfSteps = obj.numberOfSteps + 1;
        end
    end
end
