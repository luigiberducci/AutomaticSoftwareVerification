%{
Sylver Simulator Driver v 1.0
%}

%{
MIT License

Copyright (c) 2016 	Federico Mari <mari@di.uniroma1.it>
					Toni Mancini <tmancini@di.uniroma1.it>
					Annalisa Massini <massini@di.uniroma1.it>
					Igor Melatti <melatti@di.uniroma1.it>
					Enrico Tronci <tronci@di.uniroma1.it>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}

function [ propertyValue ] = simulator_driver_get_property_value()
%SIMULATOR_DRIVER_GET_PROPERTY_VALUE returns the value of bool for the fuel

% The function returning monitor value (0 or 1) must be in 'simulator_driver_get_property_value.m'
% ATTENTION: 0 means no error
% ATTENTION: 1 means an error has been found
%
    % The system block containing the output of the monitor is stored in a
    % global variable called bool.
    % The user can access to such a variable, depending on how it is
    % defined, in order to access the value of the output of the monitor.
    global bool;

%% DEFINITION OF THE FUNCTION
% From the user
    
    try
        propertyValue = bool.signals.values(end);
 
    catch err
        fprintf('[Simulink] bool does not exist\n');
        disp(err);
        propertyValue = '0';
        exit;
 
    end

end
