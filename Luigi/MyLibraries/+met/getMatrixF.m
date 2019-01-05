function [F] = getMatrixF(A, h, algo)
%% GETMATRIXF Returns the matrix F according to the algorithm `algo`.
%  This function compute the matrix F based on the matrix `A` and the time
%  step `h`.
    Ah = h*A;           % Scalar product
    I  = eye(size(A));  % Identity matrix

    if algo=="FE"
        % x_{k+1} = x_{k} + h*dx_{k}/dt =
        %         = x_{k} + h*A*x_{k} =
        %         = [I+h*A] * x_{k}
        F = I + Ah;
    elseif algo=="BE"
        % x_{k+1} = x_{k} + h*dx_{k+1}/dt =
        %         = x_{k} + h*A*x_{k+1} =
        % x_{k+1} - h*A*x_{k+1} = x_{k}
        % [I-h*A]*x{k+1} = x_{k}
        % x_{k+1} = inv[I-h*A] * x_{k}
        F = inv(I - Ah);
    elseif algo=="PC"
        % x_{p}_{k+1} = x_{k} + h*dx_{k}/dt = x_{k} + h*A*x_{k}
        % x_{c}_{k+1} = x_{k} + h*dx_{p}_{k+1}/dt =
        %             = x_{k} + h*A*(x_{k} + h*A*x_{k}) =
        %             = x_{k} + h*A*x_{k} + ((h*A)^2)*x_{k}) =
        %             = [I+h*A+(h*A)^2] * x_{k}
        F = I + Ah + Ah^2;
    elseif algo=="HE"
        % x_{p}_{k+1} = x_{k} + h*dx_{k}/dt = x_{k} + h*A*x_{k}
        % x_{c}_{k+1} = x_{k} + 1/2*h*(dx_{k}/dt + dx_{p}_{k+1}/dt) =
        %             = x_{k} + 1/2*h*(A*x_{k} + A*(x_{k} + h*A*x_{k})) =
        %             = x_{k} + 1/2*h*(2*A*x_{k} + h*A*A*x_{k}) =
        %             = x_{k} + h*A*x_{k} + ((h*A)^2)/2*x_{k} =
        %             = [I+h*A+((h*A)^2)/2] * x_{k}
        F = I + Ah + 1/2*(Ah^2);
    elseif algo=="EMR"
        % x_{p}_{k+1} = x_{k} + h/2*dx_{k}/dt = x_{k} + h/2*A*x_{k}
        % x_{c}_{k+1} = x_{k} + h*(dx_{p}_{k+1}/dt) =
        %             = x_{k} + h*(A*(x_{k} + h/2*A*x_{k})) =
        %             = x_{k} + h*(A*x_{k} + h/2*A*A*x_{k}) =
        %             = x_{k} + h*A*x_{k} + 1/2*((h*A)^2)*x_{k}) =
        %             = [I+h*A+((h*A)^2)/2] * x_{k}
        F = I + Ah + 1/2*(Ah^2);
    elseif algo=="RK2"
        % RK2 is 2-th order accurate. Omit derivation details.
        % See notes on tablet to further details.
        F = I + Ah + 1/2*(Ah^2);
    elseif algo=="RK3"
        % RK3 is 3rd order accurate. Part of the derivation is reported
        % here, the remaining part is in the notes on tablet:
        % x_{p1} = x_{k} + h/2*(dx_{k}/dt)
        % x_{p2} = x_{k} -h*(dx_{k}/dt) + 2*h*(dx_{p1}/dt)
        % x_{k+1} = x_{k} + h/6*((dx_{k}/t) + 4*(dx_{p1}/t) + (dx_{p2}/t))=
        %         = x_{k} + Ah*x_{k} + 1/2*(Ah^2)*x_{k} + 1/6*(Ah^3)*x_{k}=
        %         = [I + Ah + 1/2*(Ah^2) + 1/6*(Ah^3)] * x_{k}
        F = I + Ah + 1/2*(Ah^2) + 1/6*(Ah^3);
    elseif algo=="RK4"
        % RK4 is 4-th order accurate. Omit derivation details.
        % x_{k+1} = x_{k} + h*[1/6*(dx_{p1}/dt) + 1/3*(dx_{p2}/dt) +
        %                      1/3*(dx_{p3}/dt) + 1/6*(dx_{p4}/dt)] = 
        %         = x_{k} + (A*h)*x_{k} + 1/2*((A*h)^2)*x_{k} +
        %                 + 1/6*((A*h)^3)*x_{k} + 1/24*((A*h)^4)*x_k =
        %         = [I + Ah + (Ah^2)/2 + (Ah^3)/6 + (Ah^4)/24] * x_k
        F = I + Ah + 1/2*(Ah^2) + 1/6*(Ah^3) + 1/24*(Ah^4);
    elseif algo=="BDF1"
        % Equal to Backward Euler
        F = inv(I - Ah);
    elseif algo=="BDF2"
        % Details omitted, see notes on tablet. Basic idea: Since we need
        % to store a previous state, add a variable z_{pre} and convert the
        % state-space model from x representation to z representation.
        % The F matrix resulting is:
        % [0(n), Id(n);
        %   k1M,  k2M ]
        % Where M := inv(I-c*Ah),  0(n) is the zero matrix, Id(n) identity,
        %       c is the "future state" coefficent in BDF2 (-2/3), 
        %       k1 and k2 are the past state coefficents of BDF2 (4/3 and -1/3).
        M = inv(I - 2/3*Ah);
        O = zeros(size(A));
        F = [     O,     I;
             -1/3*M, 4/3*M];
    elseif algo=="BDF3"
        % Details omitted, see notes on tablet. 
        M = inv(I - 6/11*Ah);
        O = zeros(size(A));
        F = [     O,       I,       O;
                  O,       O,       I;
             2/11*M, -9/11*M, 18/11*M];
    elseif algo=="BDF4"
        % Details omitted, see notes on tablet. 
        M = inv(I - 12/25*Ah);
        O = zeros(size(A));
        F = [      O,       I,        O,     O;
                   O,       O,        I,     O;
                   O,       O,        O,     I;
             -3/25*M, 16/25*M, -36/25*M, 48/25*M];
    elseif algo=="BDF5"
        % Details omitted, see notes on tablet. 
        M = inv(I - 60/137*Ah);
        O = zeros(size(A));
        F = [       O,         I,          O,          O,          O;
                    O,         O,          I,          O,          O;
                    O,         O,          O,          I,          O;
                    O,         O,          O,          O,          I;
             12/137*M, -75/137*M,  200/137*M, -300/137*M,  300/137*M];
    elseif algo=="BDF6"
        % Details omitted, see notes on tablet. 
        M = inv(I - 60/147*Ah);
        O = zeros(size(A));
        F = [        O,        I,          O,         O,          O,         O;
                     O,        O,          I,         O,          O,         O;
                     O,        O,          O,         I,          O,         O;
                     O,        O,          O,         O,          I,         O;
                     O,        O,          O,         O,          O,         I;
             -10/147*M, 72/147*M, -225/147*M, 400/147*M, -450/147*M, 360/147*M];
    end
end

