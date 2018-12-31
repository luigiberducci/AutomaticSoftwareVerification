% Parameters
T = 1;          % Sampling time of DTS
Tf = 10;        % Time horizon of DTS

nCE  = 1;       % Number of counter-examples that you want
nSim = 100000;    % Max number of simulation available

CE = [[]];      % Set of CE
kCE = 0;        % Number of CE found

% Create the DTS model
system = create_model(Tf, T);
time   = [0: T: Tf];

i=0;
while kCE<nCE && i<=nSim  
    trace = rand_input(Tf, T);
    % Simulate the choosen trace `next_trace`
    [y, t, x] = lsim(system, trace, time);
    state_rho = Inf;
    for k = 1:length(x)
        state = x(k);
        state_rho = min(state_rho, rho(state, time(length(time))));
    end
    
    if state_rho<=0
        CE(kCE+1, :) = trace;
        kCE = kCE + 1;
    end
    
    i = i + 1;
    fprintf("Simulation Number: %d\n", i);
end