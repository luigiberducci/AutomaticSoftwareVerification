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
% The definition of structure currinput must be in 'simulator_driver_get_params.m'
% The commands to execute in order to set system blocks from structure currinput must be in 'simulator_driver_set_params.m'
% The dictionary must be put in 'dictionary.txt', without comments
% The function returning monitor value (0 or 1) must be in 'simulator_driver_get_property_value.m'

% Accepted commands:
%   - run:     R<time>
%   - store:   S<id>
%   - load:    L<id>
%   - free:    F<id>
%   - input:   I<str>

import java.io.*;
import java.util.*;

% Global variables to be defined by the user
global simcampaign_file_name;
global simcampaign_header_file_name;
global disturbance_dictionary_file_name;
global coverage_file_name;
global times_log_file_name;
global property_module_name;
global SUV_and_monitor;
global currinput;
global bool;
global sampling_time;
global coverage_print_step;
global debugging_level;
global loggingOn;

simulator_driver_init;

% Read Dictionary file in order to know disturbances
[ res_read_dict, dictionary ] = simulator_driver_read_dictionary(disturbance_dictionary_file_name, debugging_level);
if (res_read_dict > 0)
    disp('Problems reading the dictionary');
    return;
end
assert(~dictionary.isEmpty, 'ERROR: Disturbance dictionary is empty!');

% Read header file in order to know simulation campaign parameters
[ res_read_header, header_params ] = simulator_driver_read_header(simcampaign_header_file_name);
if (res_read_header > 0)
    return;
end

if (debugging_level > 0)
    fprintf('sampling_time       = %d\n', sampling_time);
    fprintf('coverage_print_step = %d\n', coverage_print_step);
    fprintf('coverage_file_name = %s\n', coverage_file_name);
    fprintf('debugging_level = %d\n', debugging_level);
    fprintf('disturbance_dictionary_file_name = %s\n', disturbance_dictionary_file_name);
    fprintf('simcampaign_file_name = %s\n', simcampaign_file_name);
    fprintf('simcampaign_header_file_name = %s\n', simcampaign_header_file_name);
    if loggingOn
        fprintf('loggingOn = true\n');
    else
        fprintf('loggingOn = false\n');
    end
    fprintf('\nHeader parameters:');
    disp(header_params);
end

% Load system and get initial parameters
fprintf('Simulink Driver: Loading SUV and Monitor with property monitor\n');
load_system(SUV_and_monitor);

simulator_driver_get_params;

if (debugging_level > 19)
    set_param(0, 'CallbackTracing', 'on');
end

% Remove warnings
fprintf('Simulink Driver: warnings off\n');
set_param(SUV_and_monitor, 'InitInArrayFormatMsg', 'None');
warning off;

if loggingOn
    set_param(SUV_and_monitor, 'SignalLogging', 'on');
    % Retrieve logged signals from system
    % PRE: SUV is already loaded
    mdlsignals = find_system(gcs,'FindAll','on','LookUnderMasks','all',...
            'FollowLinks','on','type','line','SegmentType','trunk');
    ph = get_param(mdlsignals,'SrcPortHandle');
    los = {};
    lot = [];
    for i=1:length(ph)
        if (strcmp(get_param(ph{i},'datalogging'), 'on'))
            los{end+1} = get_param(ph{i}, 'name');
            lot{end+1} = timeseries;
        end
    end
    if (debugging_level > 0)
        fprintf('\nLogged signals are:\n');
        for i=1:length(los)
            fprintf('  %s\n', char(los(i)));
        end
        fprintf('\n');
    end
    loggedSignals = containers.Map(los, lot);
    clear mdlsignals ph los lot;
else
    set_param(SUV_and_monitor, 'SignalLogging', 'off');
end


% Execute the simulation campaign

% Set callback function invoked each time a simulation starts
set_param(SUV_and_monitor, 'StartFcn', 'simulator_driver_set_params');

% Structure for simulation
paramNameValStruct.SaveFinalState            = 'on';
paramNameValStruct.SaveCompleteFinalSimState = 'on';
paramNameValStruct.FinalStateName            = 'xFinal';
paramNameValStruct.LoadInitialState          = 'off';
paramNameValStruct.InitialState              = 'xInitial';
if loggingOn
    paramNameValStruct.SignalLogging             = 'on';
    paramNameValStruct.SignalLoggingName         = 'logsout';
end

currentSnapshotTime = 0;

% Open input file
[fid, error_message] = fopen(simcampaign_file_name, 'r');
if (fid == -1)
    fprintf('Simulink Driver error: %s', error_message);
    return;
end


% Starts measuring execution time
tStart = tic;

% We store trace from inital state to give a counterexample, if need be
clear trace_from_root;
% initialize trace_from_root (to which we will add only R and I commands)
trace_from_root = char();

fprintf('Simulink Driver: SIMULATION STARTS\n');

% Set the initial number of traces in order to print coverage
number_of_traces = 0;
% [coverage_fid, error_message] = fopen(coverage_file_name, 'w');
% if (coverage_fid == -1)
%     fprintf('Simulink Driver error: %s', error_message);
%     return;
% end

% Open file for dumping information on current time (for statistics)
[times_fid, times_error_message] = fopen(times_log_file_name, 'w');
if (times_fid == -1)
    fprintf('Simulink Driver error: %s', times_error_message);
    return;
end

inputLine = fgetl(fid);
while ischar(inputLine)

    toks = regexp(inputLine, '[\W]*([SLRIF])[\W]*([0-9]*)[\W]*$', 'tokens');
    % assert(length(toks)==1, '''%s'' is not a valid command!', line);
    cmd = toks{1}{1};
    arg = toks{1}{2};
    % cmd = regexprep(inputLine(1), '\W', '');
    % arg = regexprep(inputLine(2:length(inputLine)), '\W', '');

    % DEBUGGING
    if (debugging_level > 9)
        fprintf('%s%s\n', cmd, arg);
    end

    % increase the number of traces, if need be
    % print coverage, if need be
    if (strcmp(cmd, header_params.TraceCmd))
        number_of_traces = number_of_traces+1;
        if (mod(number_of_traces, coverage_print_step) == 0)
            [coverage_fid, coverage_error_message] = fopen(coverage_file_name, 'a');
            if (coverage_fid == -1)
                fprintf('Simulink Driver error: %s', coverage_error_message);
                return;
            end
            fprintf(coverage_fid, '%f %f\n', toc(tStart), number_of_traces/header_params.TracesNum);
            fclose(coverage_fid);
        end
    end

    % next (R<time>)
    if strcmp(cmd, 'R')
        % R<time>
        % Parameter time is a cell, so it must be converted to string and
        % then to double (there is not a direct conversion)
        time_slice = currentSnapshotTime + sampling_time * str2num(arg);
        paramNameValStruct.StopTime = sprintf('%ld', time_slice);
        simOut = sim(SUV_and_monitor, paramNameValStruct);
        % store xInitial for next simulation step
        xInitial = simOut.get('xFinal');
        % store snapshotTime for next run
        currentSnapshotTime = simOut.get('xFinal').snapshotTime;
        % store bool for error checking
        bool = simOut.get(property_module_name);
        % LoadInitialState is off only on the first run
        paramNameValStruct.LoadInitialState = 'on';
        % Add operation to trace
        trace_from_root = char(trace_from_root, strcat(cmd, arg));

        if loggingOn
            simulator_driver_log_signals(simOut, loggedSignals);
        end

        % CHECK PROPERTY (function returns 1 iff an error has been found)
        if (simulator_driver_get_property_value())
            fprintf('ERROR FOUND IN FOLLOWING STATE:\n');
            fprintf(simulator_driver_dump_state(xInitial.loggedStates));
            fprintf('=======================\n');
            fprintf('ERROR TRACE IS AS FOLLOWS:\n');
            disp(trace_from_root);
            fprintf('=======================\n');
            fprintf('simulator_driver_get_property_value: %d\n\n', simulator_driver_get_property_value());
            fprintf('\n');
            fprintf('=======================\n');
            fprintf('==        FAIL       ==\n');
            fprintf('=======================\n');
            fprintf('\n');

            % Displays time needed to execute the simulation campaign
            toc(tStart);

            if loggingOn
                simulator_driver_log_signals_save(loggedSignals);
            end

            exit;
        end

        % DEBUGGING
        if (debugging_level > 19)
            fprintf('snapshotTime: %d\n', currentSnapshotTime);
            fprintf('simulator_driver_get_property_value: %d\n\n', simulator_driver_get_property_value());
            fprintf(simulator_driver_dump_state(xInitial.loggedStates));
            fprintf('=======================\n');
        end

    % store (S<id>)
    elseif strcmp(cmd, 'S')
        % Save all except number_of_traces and tStart which are global
        save([arg], '-regexp', '^(?!(number_of_traces|tStart|cmd|arg)$).')

    % load (L<id>)
    elseif strcmp(cmd, 'L')
        clear xInitial;
        clear currentSnapshotTime;
        clear bool;
        clear currinput;
        clear trace_from_root;
        % load state with label <id>
        load(arg);
        % set switches as they were when saved the simulation state
        simulator_driver_set_params;
        % initial state (label 1) does not read initial values
        if strcmp(arg, '1')
            paramNameValStruct.LoadInitialState = 'off';
        else
            % DEBUGGING
            if (debugging_level > 19)
                fprintf('snapshotTime: %d\n', currentSnapshotTime);
                fprintf('simulator_driver_get_property_value: %d\n\n', simulator_driver_get_property_value());
                fprintf(simulator_driver_dump_state(xInitial.loggedStates));
                fprintf('=======================\n');
                fprintf('TRACE FROM ROOT\n');
                disp(trace_from_root);
                fprintf('=======================\n');
                fprintf('\n\n');
            end
        end

    % free (F<id>)
    elseif strcmp(cmd, 'F')
        % physically delete file
        statefilename = strcat([arg], '.mat');
        delete([statefilename]);

    % input (I<id>)
    elseif strcmp(cmd, 'I')
        % INJECT DISTURBANCE FOLLOWING INPUT DISTURBANCE DICTIONARY
        % 'None' means do nothing
        vals = dictionary.get(arg);
        %assert(length(vals)>0, '''I%s'' is not a valid disturbance!', arg);
        if (debugging_level > 19)
            fprintf('dictionary.get(%s) : ', arg);
            disp(vals);
        end
        for currindex = 1:length(vals)
            vals_i = vals(currindex);
            if (~strcmpi(vals_i(1), 'NONE'))
                currinput.(char(vals_i(1))) = char(vals_i(2));
                if (debugging_level > 19)
                    fprintf('currinput.%s = %s\n', char(vals_i(1)), char(vals_i(2)));
                end
            end
        end
        if (debugging_level > 19)
            fprintf('currinput after I%s:\n', arg);
            disp(currinput);
        end
        % Add operation to trace (always, even if its NONE
        trace_from_root = char(trace_from_root, strcat(cmd, arg));

    else
        fprintf('Command ''%s%s'' not supported. Skipping!\n', cmd, arg);

    end

    % Dumping information on current time (for statistics)
    fprintf(times_fid, '%s%s\t%f\n', cmd, arg, toc(tStart));

    % Read next command in simulation campaign
    inputLine = fgetl(fid);
end

fprintf('Simulink Driver: SIMULATION ENDS\n');

if loggingOn
    simulator_driver_log_signals_save(loggedSignals);
end

fprintf('\n');
fprintf('=======================\n');
fprintf('==        PASS       ==\n');
fprintf('=======================\n');
fprintf('\n');

% Displays time needed to execute the simulation campaign
toc(tStart);

% Close file for statistics
fclose(times_fid);

% Close files
fclose(fid);
% fclose(coverage_fid);
