clear;

A = [20  1;
      0 20];
x0 = [1; 1];

algo = "BDF6";

h = 2.7;
t0 = 0;
tf = 10;

simManager = sim.SimulatorFactory(algo, A, h, x0);
simManager = simManager.simulate(t0, tf);