function [U1 U2] = computeDiscreteInputSignal(obj)
    % To have `k` discretization, we have to divide by `k-1`. In
    % this way, we include lower/upperbound as legal input value.
    inputStep = (obj.inLimSup - obj.inLimInf) ./ (obj.numInputSamples-1);
    U1 = obj.inLimInf(1) : inputStep(1) : obj.inLimSup(1);
    U2 = obj.inLimInf(2) : inputStep(2) : obj.inLimSup(2);
end