% model controller
model = 'automatic_transmission_model';
simCtrl = src.ModelController(model, 10);
% disturbances
T = 0 : 10 : 100;
B = 0 : 30 : 350;
H = 1000;
hillClmb = src.HillClimbing(simCtrl, T, B, H);
[currentModel, robustness, trace] = hillClmb.run(10)
robustness
trace