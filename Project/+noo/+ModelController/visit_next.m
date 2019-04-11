save("tmp_state", 'MODEL','Sim');
originalInput = Sim.currentInput;
    
noo.ModelController.set_input(Sim.visitInput);
noo.ModelController.step_model_controller;
visitRobustness = min(simOut.Robustness.signals.values);

clear Sim;
load("tmp_state");
noo.ModelController.set_input(originalInput);