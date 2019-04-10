save("tmp_state");

currentInput = nextAction;
src.ModelController.set_input;
src.ModelController.step_model_controller;

clear xInitial;
clear currentSnapshotTime;
clear currentInput;
load("tmp_state");
src.ModelController.set_input;
