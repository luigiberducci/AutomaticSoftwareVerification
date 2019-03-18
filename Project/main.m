% model controller
tic;
model = 'automatic_transmission_model_S1';
%model = 'automatic_transmission_model_S2';
simCtrl = src.ModelController(model, 5);
init_time = toc;

% Input definition
tic;
ThrottleLimInf = 0;
BrakeLimInf = 0;
ThrottleLimSup = 100;
BrakeLimSup = 325;

numSamplesThrottle = 10;
numSamplesBrake    = 11;

inLimInf = [ThrottleLimInf BrakeLimInf];
inLimSup = [ThrottleLimSup BrakeLimSup];
numInDisc   = [numSamplesThrottle numSamplesBrake];

horizon = 30;
restarts = 5;

hillClmb = src.HillClimbing(simCtrl, inLimInf, inLimSup, numInDisc, horizon);
[currentModel, robustness, trace] = hillClmb.run(restarts);

hc_time = toc;

fprintf("Robustness: %f\n", robustness);
fprintf("Best trace:\n");
disp(trace);
fprintf("Initialization time: %f\n", init_time);
fprintf("Hill Climbing time: %f\n", hc_time);