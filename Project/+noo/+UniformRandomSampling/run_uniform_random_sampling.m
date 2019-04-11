% First, initialize model controller       
noo.ModelController.init_model_controller;

%Initialize a trace of zeros (# ctrl points x size of input)
u = zeros(1, Sim.NUMINPUTSIGNALS);
step = 1;
while Sim.currentSnapshotTime < Sim.TIMEHORIZON
	%Choose random action
    for i = 1:Sim.NUMINPUTSIGNALS  %Pick a random value for each input signal
        u(i) = randsample(IN.inLimInf(i) : IN.quantumSize(i) : IN.inLimSup(i), 1);
    end
    URS.trace(step, :) = u;
    noo.ModelController.set_input(u);
    noo.ModelController.step_model_controller;
    rob = Sim.lastRobustness;
    URS.bestRobustness = min(URS.bestRobustness, rob);
    step = step + 1;
end
    

