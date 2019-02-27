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

% The commands to execute in order to set system blocks from structure currinput must be in 'simulator_driver_set_params.m'

global currinput;

%% COMMANDS USED TO SET SYSTEM BLOCKS FROM STRUCTURE CURRINPUT
% From the user

% set_param('apollo_dap/Yaw Disturber', 'dist_ampl', currinput.YawAddError_dist_ampl);
% set_param('apollo_dap/Yaw Disturber', 'dist_freq', currinput.YawAddError_dist_freq);
% set_param('apollo_dap/Roll Disturber', 'dist_ampl', currinput.RollAddError_dist_ampl);
% set_param('apollo_dap/Roll Disturber', 'dist_freq', currinput.RollAddError_dist_freq);
% set_param('apollo_dap/Pitch Disturber', 'dist_ampl', currinput.PitchAddError_dist_ampl);
% set_param('apollo_dap/Pitch Disturber', 'dist_freq', currinput.PitchAddError_dist_freq);
% set_param('apollo_dap/Yaw Jets to Zero', 'sw', currinput.Yaw_Zero);
% set_param('apollo_dap/PR Jets to Zero', 'sw', currinput.PR_Zero);

% WRITE HERE:
