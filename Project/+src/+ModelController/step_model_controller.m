numInterval = numInterval + 1;
time_slice = currentSnapshotTime + INTERVAL;
paramNameValStruct.StopTime = sprintf('%ld', time_slice);

simOut = sim(MODEL, paramNameValStruct);
xInitial = simOut.get('xFinal');
currentSnapshotTime = simOut.get('xFinal').snapshotTime;
lastRobustness = simOut.Robustness.signals.values(end);
