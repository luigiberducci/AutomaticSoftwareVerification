function [U1 U2] = computeDiscreteInputSignal(inLimInf, inLimSup, numInputSamples)
    % To have `k` discretization, we have to divide by `k-1`. In
    % this way, we include lower/upperbound as legal input value.
    inputStep = (inLimSup - inLimInf) ./ (numInputSamples-1);
    U1 = inLimInf(1) : inputStep(1) : inLimSup(1);
    U2 = inLimInf(2) : inputStep(2) : inLimSup(2);
end