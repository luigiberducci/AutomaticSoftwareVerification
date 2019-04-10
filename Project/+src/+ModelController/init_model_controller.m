%MODELCONTROLLER Construct an instance of this class
numInterval = 0;
epsilon     = 1e-3;
            
paramNameValStruct.SaveFinalState            = 'on';
paramNameValStruct.SaveCompleteFinalSimState = 'on';
paramNameValStruct.FinalStateName            = 'xFinal';
paramNameValStruct.LoadInitialState          = 'off';
paramNameValStruct.InitialState              = 'xInitial';
paramNameValStruct.StopTime                  = string(epsilon);
paramNameValStruct.SaveOutput                = 'on';
paramNameValStruct.OutputSaveName            = 'Robustness';
            
currentInput = [0 0];
src.ModelController.set_input;

simOut = sim(MODEL, paramNameValStruct);
lastRobustness = simOut.Robustness.signals.values(end);
xInitial = simOut.get('xFinal');
currentSnapshotTime = simOut.get('xFinal').snapshotTime;
numInterval = 0;
paramNameValStruct.LoadInitialState = 'on';
