function [F] = matrixF(A, h, algo)
%% Compute the F matrix given A,h and the integration algorithm
%  The algorithm can be Forward Euler (FE), Backward Euler (BE)
%  otherwise returns empty matrix.
    Ah = A*h;
    I = eye(size(Ah));
 
    if algo=="FE"
        F = I + Ah;
    else if algo=="BE"
        F = inv(I-Ah);
    else
        F = [];
    end
end
