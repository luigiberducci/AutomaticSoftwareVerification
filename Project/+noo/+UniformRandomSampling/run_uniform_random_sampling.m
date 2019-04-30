% First, initialize model controller       
noo.ModelController.init_model_controller;

%Initialize a trace of zeros (# ctrl points x size of input)
u = zeros(1, Sim.NUMINPUTSIGNALS);
step = 1;
URS.bestRobustness = Inf;
while Sim.currentSnapshotTime < Sim.TIMEHORIZON
	%Choose random action
    for i = 1:Sim.NUMINPUTSIGNALS  %Pick a random value for each input signal
        u(i) = randsample(linspace(IN.inLimInf(i), IN.inLimSup(i), IN.numInputSamples(i)), 1);
    end
    URS.trace(step, :) = u;
    noo.ModelController.set_input(u);
    noo.ModelController.step_model_controller;
    URS.bestRobustness = min(URS.bestRobustness, Sim.lastRobustness);
    step = step + 1;
end

% Clear the workspace from useless variables
clear step;
clear u;
clear i;
    

