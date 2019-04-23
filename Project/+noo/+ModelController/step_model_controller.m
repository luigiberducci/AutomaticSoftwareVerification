Sim.numInterval = Sim.numInterval + 1;
time_slice = Sim.currentSnapshotTime + Sim.INTERVAL;
paramNameValStruct.StopTime = sprintf('%ld', time_slice);

simOut = sim(MODEL, paramNameValStruct);
Sim.xInitial = simOut.get('xFinal');
Sim.currentSnapshotTime = simOut.get('xFinal').snapshotTime;
Sim.lastRobustness = noo.ModelController.computeRobustness(simOut.Output.signals(1).values, simOut.Output.signals(2).values);
