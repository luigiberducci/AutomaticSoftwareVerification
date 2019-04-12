save("tmp_state", 'MODEL','Sim');
originalInput = Sim.currentInput;
    
noo.ModelController.set_input(Sim.visitInput);
noo.ModelController.step_model_controller;
visitRobustness = Sim.lastRobustness;   %visitRobustness is a tmp var

clear Sim;  %Otherwise we loose with this clear
load("tmp_state");
Sim.visitRobustness = visitRobustness;
noo.ModelController.set_input(originalInput);

clear visitRobustness;  %Now is useless