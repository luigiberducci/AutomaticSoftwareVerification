% Parameters
T = 1;          % Sampling time of DTS
Tf = 10;        % Time horizon of DTS

nCE  = 1;       % Number of counter-examples that you want
nSim = 100000;    % Max number of simulation available
mK   = 15;      % Initial size of Knowledge base
m    = 20;      % Number of states uniformly sampled at each iteration

CE = [];        % List of counter-examples collected
kCE = 0;        % Number of CE found
K  = [];        % Knowledge base, initialized randomly

% Create the DTS model
system = create_model(Tf, T);
time   = [0: T: Tf];
[K_trace, K_rho] = initKnowledgeBase(system, Tf, T, mK);

i = 0;
while kCE<nCE && i<=nSim
    % Train the linear regression model
    regressionModel = fitlm(K_trace, K_rho);
    
    % Take `m` traces
    next_trace = [];        % Next trace, init empty
    predicted_rho = Inf;   % and Inf rho
    for j = 1:m
        trace = rand_input(Tf, T);
        trace_rho = regressionModel.predict(trace);
        if trace_rho<=predicted_rho
            next_trace = trace;
            predicted_rho = trace_rho;
        end        
    end
    
    % Simulate the choosen trace `next_trace`
    [y, t, x] = lsim(system, next_trace, time);
    real_rho = Inf;
    for k = 1:length(x)
        state = x(k);
        real_rho = min(real_rho, rho(state, time(length(time))));
    end
    
    % Expand Knowledge base
    K_trace(length(K_trace)+1,:) = next_trace;
    K_rho(length(K_rho)+1)     = real_rho;
    
    % If counter-example is found, then add to CE
    if real_rho<=0
        CE(kCE+1, :) = next_trace;
        kCE = kCE + 1;
    end
    i = i + 1;
    
    fprintf("Size KBase: %d %d\n", length(K_trace), length(K_rho));
end

