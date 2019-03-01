%% STEP Step the simulation to the next time stage.
numInterval = numInterval + 1;
time_slice = currentSnapshotTime + interval;
paramNameValStruct.StopTime = sprintf('%ld', time_slice);

simOut = sim(SUV_and_robustness_eval, paramNameValStruct);
xInitial = simOut.get('xFinal');
currentSnapshotTime = simOut.get('xFinal').snapshotTime;
bool = simOut.Robustness.signals.values(end);