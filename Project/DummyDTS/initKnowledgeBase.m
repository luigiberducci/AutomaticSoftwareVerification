function [K_trace, K_rho] = initKnowledgeBase(system, Tf, T, m)
%% INITKNOWLEDGEBASE Return K with `m` pair `state`,`rho(state)`.
%  Select randomly `m` states and compute `rho` for each of them.
%  Then return the pairs.
time = [0:T:Tf];
K_trace = [];
K_rho   = [];
for i = 1:m
    min_rho = inf;      % Initialize rho to Inf, then take the minimum
    trace = rand_input(Tf, T);  % Create a random trace
    [y, t, x] = lsim(system, trace, time); % Simulate it
    for j = 1:length(x)   % Scan the state and take the minimum rho
       state = x(j);
       min_rho = min(min_rho, rho(state, time(length(time))));
    end
    K_trace(i,:) = trace;
    K_rho(i)   = min_rho;
end
end

