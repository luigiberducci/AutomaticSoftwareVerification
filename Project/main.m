% model controller
tic;
model = 'automatic_transmission_model_S1';
model = 'automatic_transmission_model_S2';
simCtrl = src.ModelController(model, 5);
init_time = toc;

% disturbances
tic;
T = 0 : 10 : 100;
B = 0 : 30 : 350;

H = 30;
hillClmb = src.HillClimbing(simCtrl, T, B, H);
[currentModel, robustness, trace] = hillClmb.run(10);
hc_time = toc;

fprintf("Robustness: %f\n", robustness);
fprintf("Best trace:\n");
disp(trace);
fprintf("Initialization time: %f\n", init_time);
fprintf("Hill Climbing time: %f\n", hc_time);