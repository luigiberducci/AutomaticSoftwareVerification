% model controller
model = 'automatic_transmission_model';
simCtrl = src.ModelController(model, 10);
% disturbances
T = 0 : 10: 100;
b = 0 : 30: 350;

hillClmb = src.HillClimbing(simCtrl, T, B);
[currentModel, robustness, trace] = hillClmb.run()