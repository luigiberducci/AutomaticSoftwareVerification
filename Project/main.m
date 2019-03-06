% model controller
tic;
%model = 'automatic_transmission_model_S1';
model = 'automatic_transmission_model_S2';
simCtrl = src.ModelController(model, 5);
init_time = toc;

% disturbances
tic;
% TODO: parametrize discretization of input signals.
T = 0 : 10 : 100;
B = 0 : 30 : 350;

horizon = 30;
restarts = 5;
hillClmb = src.HillClimbing(simCtrl, T, B, horizon);
[currentModel, robustness, trace] = hillClmb.run(restarts);

hc_time = toc;

fprintf("Robustness: %f\n", robustness);
fprintf("Best trace:\n");
disp(trace);
fprintf("Initialization time: %f\n", init_time);
fprintf("Hill Climbing time: %f\n", hc_time);