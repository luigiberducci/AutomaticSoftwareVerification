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

% Global variables must be defined in 'simulator_driver_init.m'

%% GLOBAL VARIABLE DECLARATIONS

% 'SUV_and_monitor' is the name of the Simulink model containing the
% System Under Verification (SUV) and the monitor checking the property
global SUV_and_monitor;

% 'property_module_name' is the name of the Simulink block containing the
% output of the monitor
global property_module_name;

% 'coverage_file_name' is the name of the output file for coverage info
global coverage_file_name;

% 'times_log_file_name' contains starting moments for each command in trace
global times_log_file_name;

% 'disturbance_dictionary_file_name' is the name of the file containing the
% disturbance dictionary
global disturbance_dictionary_file_name;

%% VARIABLE DEFINITIONS
disturbance_dictionary_file_name = 'dictionary.txt';
property_module_name             = 'bool';
coverage_file_name               = 'coverage.txt';
times_log_file_name              = 'times_log.txt';

% CHANGE HERE BELOW:
SUV_and_monitor                  = 'WRITE_SYSTEM_NAME_HERE';
