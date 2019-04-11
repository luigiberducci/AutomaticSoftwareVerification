function int = computeTimeDiscretization(timeHorizon, numCtrlPnts)
    % Il +1 serve per lasciare margine di simulazione per rollout (foglie) 
    int = timeHorizon/(numCtrlPnts+1);
end
