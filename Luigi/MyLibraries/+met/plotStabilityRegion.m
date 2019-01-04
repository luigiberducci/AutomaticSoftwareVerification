function plotStabilityRegion(algo)
%PLOTSTABILITYREGION Plot the stability region (the contourn) of the given
%integration method.
    [X, Y] = getContournPoints(algo);
    plotContourn(X, Y, algo);
end

function plotContourn(X, Y, algo)
    plot(X, Y);
    grid on;
    figureTitle = sprintf("%s Stability Region", algo);
    title(figureTitle);
end

function [X, Y] = getContournPoints(algo)
    rangeSize = getDefaultRangeSize();
    [X, Y] = getTwoEmptiesArrays(rangeSize);
    
    for i = 1:rangeSize
        [x, y] = getIthCartesianCoordinates(i, algo);
        X(i) = x;
        Y(i) = y;
    end
end

function [x, y] = getIthCartesianCoordinates(i, algo)
    [alpha, h_max] = getIthAngleAndMaxStep(i, algo);    
    display(eig(getMatrixAFromAngle(alpha)));
    [x,y] = convertPolarToCartesian(alpha, h_max);
end

function [alpha, h_max] = getIthAngleAndMaxStep(i, algo)
    [upper, lower] = getDefaultStepBounds();
    A = getTheIthAMatrix(i);
    alpha = getTheIthAlpha(i);
    h_max = met.getMaxStep(A, upper, lower, algo);
end

function [X, Y] = getTwoEmptiesArrays(size)
    X = zeros(size, 1);
    Y = zeros(size, 1);
end

function [x,y] = convertPolarToCartesian(angle, distance)
    [x, y] = pol2cart(angle, distance);
end

function [range] = getAlphaRange(rangeSize)
    range = linspace(0, 2*pi, rangeSize);
end

function [A] = getTheIthAMatrix(i)
    alpha = getTheIthAlpha(i);
    A = getMatrixAFromAngle(alpha);
end

function [alpha] = getTheIthAlpha(i)
    rangeSize = getDefaultRangeSize();
    alphaRange = getAlphaRange(rangeSize);
    alpha = alphaRange(i);
end

function [A] = getMatrixAFromAngle(alpha)
	radalpha = alpha*pi/180;
    x = cos(radalpha);
    A = [ 0,   1; 
         -1, 2*x];
end

function [rangeSize, h_upper, h_lower] = getConstants()
    rangeSize = getDefaultRangeSize();
    [h_upper, h_lower] = getDefaultStepBounds();
end

function rangeSize = getDefaultRangeSize()
    rangeSize = 50;
end

function [u, l] = getDefaultStepBounds()
    u = 1;
    l = 1e-07;
end