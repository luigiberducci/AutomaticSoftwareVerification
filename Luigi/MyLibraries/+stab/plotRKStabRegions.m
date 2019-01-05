[x2, y2] = getRK2Region();
[x3, y3] = getRK3Region();
[x4, y4] = getRK4Region();

[rows, cols] = getSubplotGridSizes();

subplot(rows, cols, 1);
plotFuncWithTitle(x2, y2, "RK2");

subplot(rows, cols, 2);
plotFuncWithTitle(x3, y3, "RK3");

subplot(rows, cols, 3);
plotFuncWithTitle(x4, y4, "RK4");

subplot(rows, cols, 4);
hold on;
plotFuncNoTitle(x2, y2);
plotFuncNoTitle(x3, y3);
plotFuncNoTitle(x4, y4);
legend("RK2", "RK3", "RK4");
title("RK Family");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliar Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, y] = getRK2Region()
    order = 2;
    [x, y] = getRKStabilityRegion(order);
end

function [x, y] = getRK3Region()
    order = 3;
    [x, y] = getRKStabilityRegion(order);
end

function [x, y] = getRK4Region()
    order = 4;
    [x, y] = getRKStabilityRegion(order);
end

function [x, y] = getRKStabilityRegion(order)
    method = getRKNameFromOrder(order);
    [x, y] = stab.getStabilityRegion(method);
end

function plotFuncWithTitle(x, y, funcName)
    plot(x, y);
    title(funcName);
    axis equal;
    grid on;
end

function plotFuncNoTitle(x, y)
    plot(x, y);
    axis equal;
    grid on;
end

function [nRows, nCols] = getSubplotGridSizes()
    nRows = 2;
    nCols = 2;
end

function methodName = getRKNameFromOrder(ord)
    methodName = sprintf("RK%d", ord);
end