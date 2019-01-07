function [freq] = getOscillationFrequency(hysteresis)
%GETOSCILLATIONFREQUENCY Return the steady-state oscillation frequency.
%   The frequency is computed as function of the hysteresis, by the
%   following formula:
%   f = 1/(2*hysteresis)
    double_hyst = 2*hysteresis;
    freq = 1/double_hyst;
end

