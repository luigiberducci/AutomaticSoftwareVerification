function [h_max] = getMaxStepImplicit(A, h_upper, h_lower, algo)
%% GETMAXSTEP Returns max step size to ensure instability of implicit method.
%  Given an implicit algorithm `algo`, the method compute the search of
%  maximum step-size to ensure numerical instability (the eigenvalues of the
%  discretized system, described by F, are inside the Unit Circle).
    maxErrTolerance = 10^-9;
    currentError    = Inf;
    k= 0;
    while currentError > maxErrTolerance && k<=10000
        h = (h_upper + h_lower)/2;      % Take middle value in the interval
        F = met.getMatrixF(A, h, algo); % Compute the F matrix (discretized system)
        
        dominantEig  = abs(max(eig(F)));     % Abs value of dominant eigenvalue
        currentError = dominantEig - 1;      % Compare with Unit Circle (UC)
        
        % Using implicit method, the logic is reversed (cause by "inverse")
        % If we observe an unstable system and the discretized version, 
        % we can observe that increasing the step-size h then the dominant
        % eigenvalue of the discretized system becomes smaller. Conversely,
        % if we reduce the step-size then the eigenvalue grows. Then we
        % have to reason in the reverse way:
        % Out of UC -> Increase h, In the UC -> Decrease h
        if currentError > 0     % Then the abs value of eig is out of UC
            h_lower = h;        % h is too small, we have to increase the lower
        else                    % Otherwise the abs value of eig is inside the UC
            h_upper = h;        % h is sufficently big, we can decrease the upper
        end
        
        currentError = abs(currentError);
        k = k+1;
    end
    h_max = h;
end

