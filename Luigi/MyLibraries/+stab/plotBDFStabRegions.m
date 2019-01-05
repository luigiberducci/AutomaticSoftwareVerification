[x1, y1] = getBDF1Region();
[x2, y2] = getBDF2Region();
[x3, y3] = getBDF3Region();
[x4, y4] = getBDF4Region();
[x5, y5] = getBDF5Region();
[x6, y6] = getBDF6Region();

[rows, cols] = getSubplotGridSizes();

subplot(rows, cols, 1);
plotFuncWithTitle(x1, y1, "BDF1");

subplot(rows, cols, 2);
plotFuncWithTitle(x2, y2, "BDF2");

subplot(rows, cols, 3);
plotFuncWithTitle(x3, y3, "BDF3");

subplot(rows, cols, 4);
plotFuncWithTitle(x4, y4, "BDF4");

subplot(rows, cols, 5);
plotFuncWithTitle(x5, y5, "BDF5");

subplot(rows, cols, 6);
plotFuncWithTitle(x6, y6, "BDF6");

subplot(rows, cols, 7);
hold on;
title("BDF Family");
plotFuncNoTitle(x1, y1);
plotFuncNoTitle(x2, y2);
plotFuncNoTitle(x3, y3);
plotFuncNoTitle(x4, y4);
plotFuncNoTitle(x5, y5);
plotFuncNoTitle(x6, y6);
legend("BDF1", "BDF2", "BDF3", "BDF4", "BDF5", "BDF6");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliar Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, y] = getBDF1Region()
    method = getBDFNameFromOrder(1);
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBDF2Region()
    method = getBDFNameFromOrder(2);
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBDF3Region()
    method = getBDFNameFromOrder(3);
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBDF4Region()
    method = getBDFNameFromOrder(4);
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBDF5Region()
    method = getBDFNameFromOrder(5);
    [x, y] = stab.getStabilityRegion(method);
end

function [x, y] = getBDF6Region()
    method = getBDFNameFromOrder(6);
    [x, y] = stab.getStabilityRegion(method);
end

function plotFuncWithTitle(x, y, funcName)
    plotFuncNoTitle(x, y);
    title(funcName);
end

function name = getBDFNameFromOrder(order)
    name = sprintf("BDF%d", order);
end

function plotFuncNoTitle(x, y)
    plot(x, y);
    axis equal;
    grid on;
end

function [nRows, nCols] = getSubplotGridSizes()
    nRows = 3;
    nCols = 3;
end