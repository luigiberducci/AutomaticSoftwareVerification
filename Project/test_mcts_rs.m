clear all;
%% Initialization
t0 = tic;
init_param;     %Simulation parameters and other config
noo.ModelController.init_model_controller; %Simulation Manager 
t_init = toc(t0);

SPEC = 2;
ALGOSRC = "RS"; % Possible values: RS, HC, SA

main_new_mcts;