%MODELCONTROLLER Construct an instance of this class
numInterval = 0;
epsilon     = 1e-3;
            
paramNameValStruct.SaveFinalState            = 'on';
paramNameValStruct.SaveCompleteFinalSimState = 'on';
paramNameValStruct.FinalStateName            = 'xFinal';
paramNameValStruct.LoadInitialState          = 'off';
paramNameValStruct.InitialState              = 'Sim.xInitial';
paramNameValStruct.StopTime                  = string(epsilon);
paramNameValStruct.SaveOutput                = 'on';
paramNameValStruct.OutputSaveName            = 'Robustness';
            
src.ModelController.set_input([0 0]);

simOut = sim(MODEL, paramNameValStruct);
Sim.lastRobustness = simOut.Robustness.signals.values(end);
Sim.xInitial = simOut.get('xFinal');
Sim.currentSnapshotTime = simOut.get('xFinal').snapshotTime;
Sim.numInterval = 0;
paramNameValStruct.LoadInitialState = 'on';
