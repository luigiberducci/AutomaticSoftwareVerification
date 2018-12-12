function [u_signal] = rand_input(t_final, sample_time)
% Create a random discrete signal.
%
% Parameters:
% -----------
%   `t_final` is the time horizon
%   `sample_time` is the sample time of the DST
% Returns:
% --------
%   `u_signal`  is an array of size (1/sample_time)*t_final
%               containing the input signal
time = [0:sample_time:t_final];
u_signal = randi([0,1], size(time))
end

