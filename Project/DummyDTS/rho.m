function rho = rho(x, Upper)
% Compute Rho of the given state with respect to Tf.
% Obviously, this is a simple implementation and very specific
% to our model and application. We should create a complete function.
%   
% Parameters:
% -----------
%       `x` is the state in which compute Rho
%       `Upper` is the upperbound in the specification `G[x<Upper]`
% Returns:
% --------
%       `rho` is the value of the distance computed according
%       to the paper definition
rho = Upper - x;
end

