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

% The definition of structure currinput must be put in 'simulator_driver_get_params.m'

%% CURRINPUT DECLARATION

% 'currinput' is a structure containing a field for each one of the block
% models in which it is possible to inject a disturbance (failures, input variation)
global currinput;


%% CURRINPUT DECLARATION
%% Example for apollo_dap
% currinput = struct('YawAddError_dist_ampl', get_param('apollo_dap/Yaw Disturber', 'dist_ampl'),...
%                    'YawAddError_dist_freq', get_param('apollo_dap/Yaw Disturber', 'dist_freq'),...
%                    'RollAddError_dist_ampl', get_param('apollo_dap/Roll Disturber', 'dist_ampl'),...
%                    'RollAddError_dist_freq', get_param('apollo_dap/Roll Disturber', 'dist_freq'),...
%                    'PitchAddError_dist_ampl', get_param('apollo_dap/Pitch Disturber', 'dist_ampl'),...
%                    'PitchAddError_dist_freq', get_param('apollo_dap/Pitch Disturber', 'dist_freq'),...
%                    'Yaw_Zero', get_param('apollo_dap/Yaw Jets to Zero', 'sw'),...
%                    'PR_Zero', get_param('apollo_dap/PR Jets to Zero', 'sw'));

% WRITE HERE currinput DECLARATION:
