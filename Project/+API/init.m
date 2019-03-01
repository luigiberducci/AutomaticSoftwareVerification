global SUV_and_robustness_eval;
global property_module_name;
global bool;
global storedState;
global interval;
global numInterval;
global paramNameValueStruct;

SUV_and_robustness_eval = 'automatic_transmission_model';        
storedState             = 'state';
property_module_name    = 'Output';
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

simOut = sim(SUV_and_robustness_eval, paramNameValStruct);
bool = simOut.get(property_module_name);
currentState = simOut.get('xFinal');
currentSnapshotTime = simOut.get('xFinal').snapshotTime;

paramNameValStruct.LoadInitialState = 'on';