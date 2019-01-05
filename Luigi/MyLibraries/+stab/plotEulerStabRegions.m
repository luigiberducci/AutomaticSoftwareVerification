[x1, y1] = getFERegion();
[x2, y2] = getBERegion();

[rows, cols] = getSubplotGridSizes();

subplot(rows, cols, 1);
plotFuncWithTitle(x1, y1, "Forward Euler");

subplot(rows, cols, 2);
plotFuncWithTitle(x2, y2, "Backward Euler");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliar Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, y] = getFERegion()
    method = "FE";
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBERegion()
    method = "BE";
    [x, y] = stab.getStabilityRegion(method);
end

function plotFuncWithTitle(x, y, funcName)
    plotFuncNoTitle(x, y);
    title(funcName);
end

function plotFuncNoTitle(x, y)
    plot(x, y);
    axis equal;
    grid on;
end

function [nRows, nCols] = getSubplotGridSizes()
    nRows = 1;
    nCols = 2;
end