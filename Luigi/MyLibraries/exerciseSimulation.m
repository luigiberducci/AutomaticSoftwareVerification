clear;

A = [20  1;
      0 20];
x0 = [1;1];

algo = "BDF6";

h = 1.3867*2;
t0 = 0;
tf = 10;

simManager = sim.SimulatorFactory(algo, A, h, x0);
simManager = simManager.simulate(t0, tf);



function [x] = simLTI(A, x0, t0, h, tf)
    time = getTimeVector(t0, h, tf);

    % Create simulator
    ss = sim.BackwardEuler(h, A, x0);

    for i = 1:size(time, 2)-1
        ss = ss.step();
    end

    x = ss.getTrajectory();
    plot(time, x);
end

function [time] = getTimeVector(t0, h, tf)
    time = t0:h:tf;
end