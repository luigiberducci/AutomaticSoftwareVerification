function [T] = getLTIErrorMatrixT(A)
%GETERRORMATRIXT Returns the matrix T computed by the Eq.12.27 (page 562).
% Given an LTI system dx = A*x, 
% call L the diagonal matrix of eigenvalues and 
% V the matrix with eigenvectors in columns, 
% then the global error bound is defined by the following formula: 
%   |x(t) - xa(t)| = |V| |inv(Real(L))*L| |inv(V)|

    [V] = getMatrixOfEigenVectors(A);
    [L] = getDiagonalMatrixOfEigenvalues(A);
    
[T] = abs(V) * abs((real(L))\L) * abs(inv(V));
end

function [V] = getMatrixOfEigenVectors(A)
    [V, L] = eig(A);
end

function [L] = getDiagonalMatrixOfEigenvalues(A)
    [V, L] = eig(A);
end

