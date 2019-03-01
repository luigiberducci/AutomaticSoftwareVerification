% model controller
model = 'automatic_transmission_model';
simCtrl = src.ModelController(model, 10);
% disturbances
T = [10 20 30 40 50 60 70 80 90 100];
B = [10 20 30 40 50 60 70 80 90 100];

hillClmb = src.HillClimbing(simCtrl, T, B);
[currentModel, robustness, trace] = hillClmb.run()