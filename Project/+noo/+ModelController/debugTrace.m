% PRE:  DBG.trace must be valued
%       DBG.spec must be valued

% Reset to time 0
noo.ModelController.init_model_controller

% Simulate
speed = [];
gear = [];
for i=1:Sim.NUMCTRLPOINTS+1
    u = DBG.trace(i, :);
    noo.ModelController.set_input(u);
    noo.ModelController.step_model_controller;
    speed = [speed; simOut.Output.signals(1).values];
    gear = [gear; simOut.Output.signals(2).values];
end

close all;
timeSteps = length(speed);
time = linspace(0, Sim.TIMEHORIZON, timeSteps);

plot(time, speed);
hold on;
plot(time, gear);

%Plot reference line
ref = zeros(size(speed));
switch DBG.spec
    case 1
        refSpeed = 120;
        ref = refSpeed * ones(size(speed));
    case 2
        refSpeed = 20;
        ref = refSpeed * ones(size(speed));
end
hold on;
plot(time, ref);