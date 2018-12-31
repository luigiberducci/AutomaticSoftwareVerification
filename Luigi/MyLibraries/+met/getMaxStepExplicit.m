function [h_max] = getMaxStepExplicit(A, h_upper, h_lower, algo)
%% GETMAXSTEP Returns the max step size to ensure stability of explicit method.
%  Given an explicit algorithm `algo`, the method compute the search of
%  maximum step-size to ensure numerical stability (the eigenvalues of the
%  discretized system, described by F, are inside the Unit Circle).
    maxErrTolerance = 10^-3;
    currentError    = Inf;
    numberOfIterations = 0;
    
    while currentError > maxErrTolerance && numberOfIterations<=1000
        h = (h_upper + h_lower)/2;      % Take middle value in the interval
        F = met.getMatrixF(A, h, algo); % Compute the F matrix (discretized system)
        
        dominantEig  = abs(max(eig(F)));     % Abs value of dominant eigenvalue
        currentError = dominantEig - 1;      % Compare with Unit Circle (UC)
        
        if currentError > 0     % Then the abs value of eig is out of UC
            h_upper = h;        % h is too big, we have to reduce its upperbound
        else                    % Otherwise the abs value of eig is inside the UC
            h_lower = h;        % h is sufficently small, we can exceed the lowerbound
        end
        
        currentError = abs(currentError);
        numberOfIterations = numberOfIterations + 1;
    end
    h_max = h;
end

