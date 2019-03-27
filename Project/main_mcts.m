% model controller
%tic;
model = 'automatic_transmission_model_S1';
%model = 'automatic_transmission_model_S2';
%simCtrl = src.ModelController(model, 5);
%init_time = toc;

% Input definition
tic;
ThrottleLimInf = 0;
BrakeLimInf = 0;
ThrottleLimSup = 100;
BrakeLimSup = 325;

numSamplesThrottle = 10;
numSamplesBrake    = 11;

numRegionThrottle = 2;
numRegionBrake    = 5;

inLimInf = [ThrottleLimInf BrakeLimInf];
inLimSup = [ThrottleLimSup BrakeLimSup];
numInDisc   = [numSamplesThrottle numSamplesBrake];

numInRegion = [numRegionThrottle numRegionBrake];

simTimeHorizon = 30;
numCtrlPnts = 5;

mcts = src.MCTS(model, inLimInf, inLimSup, numInDisc, numInRegion, simTimeHorizon, numCtrlPnts)
nodeID = mcts.selection();
mcts = mcts.expansion(nodeID);
mcts = mcts.preRollout(nodeID);
