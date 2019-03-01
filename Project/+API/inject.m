%% SETINPUT Change the current input signals with `inputSignal` content.
set_param(SUV_and_robustness_eval+"/Throttle", "Value", string(inputSignal(1)));
set_param(SUV_and_robustness_eval+"/Brake", "Value", string(inputSignal(2)));