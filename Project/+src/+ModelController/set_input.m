function set_input(U)
    global Sim; 
    global MODEL;
    Sim.currentInput = U;
    set_param(MODEL+"/Throttle", "Value", string(U(1)));
    set_param(MODEL+"/Brake",    "Value", string(U(2)));
end
