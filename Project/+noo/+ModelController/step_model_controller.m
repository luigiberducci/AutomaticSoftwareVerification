Sim.numInterval = Sim.numInterval + 1;
time_slice = Sim.currentSnapshotTime + Sim.INTERVAL;
paramNameValStruct.StopTime = sprintf('%ld', time_slice);

simOut = sim(MODEL, paramNameValStruct);
Sim.xInitial = simOut.get('xFinal');
Sim.currentSnapshotTime = simOut.get('xFinal').snapshotTime;
Sim.lastRobustness = min(simOut.Robustness.signals.values);
