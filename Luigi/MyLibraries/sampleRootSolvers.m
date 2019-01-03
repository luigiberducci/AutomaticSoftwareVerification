%% Test implementation of root solversclear;syms x;f = @(x) x^3 - 2*x - 5;df = matlabFunction( diff(f, x) );  % Derivative of `f`a = 2;b = 3;tolerance = 1e-9;maxIterations = 50;% Collection of root solvers and relative convergencesolvers   = {};converged = [];% Regula FalsiRF = root.RegulaFalsi(f, a, b, tolerance);% Newton IterationNI = root.NewtonIteration(f, df, a, b, tolerance);% Cubic polynomial interpolationIP3 = root.InterPoly3(f, df, a, b, tolerance);% Inverse cubic polynomialICP = root.InverseCubicPoly(f, df, a, b, tolerance);% Single-step methodsIP3 = IP3.nextIteration();ICP = ICP.nextIteration();% Iterative methodsfor i = 1:maxIterations    if not(RF.isConverged())        RF = RF.nextIteration();    end    if not(NI.isConverged())        NI = NI.nextIteration();    endend% Plot resultsfigure(1);RF.plot();figure(2);NI.plot();figure(3);IP3.plot();figure(4);ICP.plot();% Print statisticsfprintf("%s: Converged? %d  | Iterations? %d\n", "RF", RF.isConverged(), RF.iters );fprintf("%s: Converged? %d  | Iterations? %d\n", "NI", NI.isConverged(), NI.iters );fprintf("%s: Converged? %d  | Iterations? %d\n", "IP3", IP3.isConverged(), IP3.iters );fprintf("%s: Converged? %d  | Iterations? %d\n", "ICP", ICP.isConverged(), ICP.iters );