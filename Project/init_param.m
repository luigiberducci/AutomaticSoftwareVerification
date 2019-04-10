%Model filename
MODEL = 'automatic_transmission_model_S1';
% model = 'automatic_transmission_model_S2';
%model = 'automatic_transmission_model_S4';

SIMTIMEHORIZON = 30;
NUMCTRLPOINTS = 2;
INTERVAL = src.computeTimeDiscretization(SIMTIMEHORIZON, NUMCTRLPOINTS);
currentInput = [0 0];

load_system(MODEL);
