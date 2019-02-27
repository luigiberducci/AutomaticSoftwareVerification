epsilon = 1e-3;
model = 'automatic_transmission_model';            
interval = 10;
numInterval = 0;

open_system(model, 'loadonly')

set_param(model,'SaveFinalState','on','FinalStateName',...
'myOperPoint','SaveCompleteFinalSimState','on');
simOut = sim(model, 'StopTime', string(epsilon));
currentState = simOut.get('myOperPoint');