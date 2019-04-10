save("tmp_state", 'MODEL','Sim');
originalInput = Sim.currentInput;
    
src.ModelController.set_input(Sim.visitInput);
src.ModelController.step_model_controller;
visitRobustness = min(simOut.Robustness.signals.values);

clear Sim;
load("tmp_state");
src.ModelController.set_input(originalInput);