function [U1, U2] = computeDiscreteInputSignal(inLimInf, inLimSup, numInputSamples)
    % To have `k` discretization, we have to divide by `k-1`. In
    % this way, we include lower/upperbound as legal input value.
    U1 = linspace(inLimInf(1), inLimSup(1), numInputSamples(1));
    U2 = linspace(inLimInf(2), inLimSup(2), numInputSamples(2));
end