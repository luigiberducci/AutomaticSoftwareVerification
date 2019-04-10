% First, initialize model controller       
src.ModelController.init_model_controller;

%Initialize a trace of zeros (# ctrl points x size of input)
u = zeros(1, Sim.NUMINPUTSIGNALS);
step = 1;
while Sim.currentSnapshotTime < Sim.TIMEHORIZON
	%Choose random action
    for i = 1:Sim.NUMINPUTSIGNALS  %Pick a random value for each input signal
        u(i) = randsample(inLimInf(i) : quantumSize(i) : inLimSup(i), 1);
    end
    URS.trace(step, :) = u;
    src.ModelController.set_input(u);
    src.ModelController.step_model_controller;
    rob = Sim.lastRobustness;
    URS.bestRobustness = min(URS.bestRobustness, rob);
    step = step + 1;
end
    

