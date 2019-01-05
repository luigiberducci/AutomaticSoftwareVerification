classdef Simulator
    %% Simulator: interface of all simulator objects
    %  It provides few basic and common API that each simulator has to
    %  implement.
    
    % Properties of simulator
    properties
        trajectory        
        numberOfSteps
        h
        A
        x0
    end
    
    % Abstract methods that each simulator has to implement
    methods (Abstract)
        step(obj); % Step forward the simulation
    end
    
    % Common methods in all the simulators
    methods
        function obj = Simulator(h, A, x0)
            %% SIMULATOR Construct an instance of this object
            obj.trajectory(1,:) = x0;
            obj.numberOfSteps = 0;
            obj.h  = h;
            obj.x0 = x0;
            obj.A  = A;
        end
        function traj = getTrajectory(obj)
            %% GET TRAJECTORY Returns the trajectory computed up to now.
            traj = obj.trajectory;
        end
        function obj = reset(obj)
            %% RESET Overwrite simulation and reset its content.
            obj.trajectory = [];
            obj.trajectory(1, :) = obj.x0;
            obj.numberOfSteps = 0;
        end
    end
end

