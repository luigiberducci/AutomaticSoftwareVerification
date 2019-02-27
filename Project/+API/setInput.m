%% SETINPUT Change the current input signals with `u`.
set_param(obj.model+"/Throttle", "Value", string(u(1)));
set_param(obj.model+"/Brake", "Value", string(u(2)));