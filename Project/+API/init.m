global SUV_and_robustness_eval;
global property_module_name;
global bool;
global storedState;
global interval;
global numInterval;
global paramNameValueStruct;
global inputSignal;

SUV_and_robustness_eval = 'automatic_transmission_model';        
storedState             = 'state';
interval    = 10;
numInterval = 0;
epsilon     = 1e-3;

load_system(SUV_and_robustness_eval)

paramNameValStruct.SaveFinalState            = 'on';
paramNameValStruct.SaveCompleteFinalSimState = 'on';
paramNameValStruct.FinalStateName            = 'xFinal';
paramNameValStruct.LoadInitialState          = 'off';
paramNameValStruct.InitialState              = 'xInitial';
paramNameValStruct.StopTime                  = string(epsilon);
paramNameValStruct.SaveOutput                = 'on';
paramNameValStruct.OutputSaveName            = 'Robustness';

simOut = sim(SUV_and_robustness_eval, paramNameValStruct);
bool   = simOut.Robustness.signals.values(end);
xInitial = simOut.get('xFinal');
currentSnapshotTime = simOut.get('xFinal').snapshotTime;

paramNameValStruct.LoadInitialState = 'on';