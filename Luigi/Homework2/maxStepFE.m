function [h_max] = maxStepFE(A, h_upper, h_lower)
%% Compute the maximum step size for stability with FE integration method
    max_err = 10^-9;    % Tolerance
    err = Inf;          % Initial error
    while err>max_err
        h = (h_lower + h_upper)/2;
        F = matrixF(A, h, "FE");
        max_eig = abs(max(eig(F)));

        err = max_eig - 1;
        if err>0
            h_upper = h;    %Out of the unit circle
        else
            h_lower = h;    %Inside the unit circle
        end
        err = abs(err);
    end
    h_max = h;
end
