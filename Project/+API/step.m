%% STEP Step the simulation to the next time stage.
numInterval = numInterval + 1;
set_param(model, 'LoadInitialState', 'on',...
          'InitialState', 'myOperPoint');
sim(model, 'StopTime', (numInterval)*interval);