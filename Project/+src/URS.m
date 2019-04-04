classdef URS
    properties
        %Model properties
        modelCtrl    %Manager of model simulation
        
        %Input signal properties
        inLimInf     %Lowerbound of input signals
        inLimSup     %Upperbound of input signals
        numInputDisc %Discretization of input signals
        quantumSize  %Space quantum (derived by `numInputDisc`)
        
        %Simulation properties
        simTimeHorizon  %Time horizon
        numCtrlPoints   %Discretization of time
    end
    methods
        function obj = URS(modelCtrl, inLimInf, inLimSup, numInDisc, simTimeHorizon, numCtrlPnts)
            %% URS: Constructor of Uniform Random Sample Algorithm.
            % Parameters
            % -`modelCtrl`: ModelController object, simulation manager
            % -`inLimInf`:  vector of input lowerbounds
            % -`inLimSup`:  vector of input upperbounds
            % -`numInDisc`: vector of input discretization (num of samples)
            % -`simTimeHorizon`: simulation time horizon
            % -`numCtrlPnts`: time discretization (num of time samples)
            obj.modelCtrl = modelCtrl;
            obj.simTimeHorizon = simTimeHorizon;
            obj.numCtrlPoints = numCtrlPnts;
            
            obj.inLimInf = inLimInf;
            obj.inLimSup = inLimSup;
            obj.numInputDisc = numInDisc;
            obj.quantumSize = (inLimSup - inLimInf) ./ numInDisc;
        end
        
        function [rob, trace] = runRandomTrace(obj)
            obj.modelCtrl = obj.modelCtrl.reset();  %Reset to t0
            %Initialize a trace of zeros (# ctrl points x size of input)
            trace = zeros(obj.numCtrlPoints, length(obj.inLimInf));
            i = 1;
            while obj.modelCtrl.currentSnapshotTime < obj.simTimeHorizon
                u = obj.chooseAction();
                trace(i, :) = u;
                obj.modelCtrl = obj.modelCtrl.setInput(u);
                obj.modelCtrl = obj.modelCtrl.step();
                i = i + 1;
            end
            rob = obj.modelCtrl.lastRobustness();
        end
        
        function u = chooseAction(obj)
            for i = 1:length(obj.inLimInf)  %Pick a random value for each input signal
                u(i) = randsample([obj.inLimInf(i) : obj.quantumSize(i) : obj.inLimSup(i)], 1);
            end
        end
    end
end
