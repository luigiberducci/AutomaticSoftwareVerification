function [h_max] = getMaxStep(A, h_upper, h_lower, algo)
%% GETMAXSTEP Returns the maximum step-size to ensure numerical stability.
% It works with explicit and implicit methods and compute respectively
% numerical stability and instability.
%
% Note that if `algo` is ForwardEuler or RungeKutta, then it considers
% explicit. Conversely, if `algo` is BackwardEuler or Backward Difference
% Formula, then it considers implicit.
    explicitMethods = {'FE', 'PC', 'HE', 'EMR', 'RK2', 'RK3', 'RK4'};
    implicitMethods = {'BE', 'BDF2'};
    
    if any(strcmp(explicitMethods, algo))
        h_max = met.getMaxStepExplicit(A, h_upper, h_lower, algo);
    elseif any(strcmp(implicitMethods, algo))
        h_max = met.getMaxStepImplicit(A, h_upper, h_lower, algo);
    else
        error("The input algorithm %s has no implementation.\n", algo);
        h_max = Inf;
    end
end

