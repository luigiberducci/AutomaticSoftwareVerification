function [x, y] = getStabilityRegion(algo)
%PLOTSTABILITYREGION Plot the stability region (the contourn) of the given
%integration method.
    sizeRange = getDefaultNumberOfSamples();    
    [minStep, maxStep] = getLimitStepSize();
    
    alphas = getAlphaRange(sizeRange);
    maxHs  = zeros(size(alphas));
    
    for i = 1:sizeRange
        A = getAlphaMatrix(alphas(i));
        hmax = met.getMaxStep(A, maxStep, minStep, algo);
        maxHs(i) = hmax;
    end
    
    [x, y] = pol2cart(alphas, maxHs);    
end

function rangeSamples = getDefaultNumberOfSamples()
    rangeSamples = 300;
end

function [min, max] = getLimitStepSize()
    min = 0.01;
    max = 100;
end

function [A] = getAlphaMatrix(alpha)
    x = cos(alpha);
    A = [ 0,   1;
         -1, 2*x];
end

function [alphas] = getAlphaRange(numSamples)
    alphas = linspace(0, 2*pi, numSamples);
end