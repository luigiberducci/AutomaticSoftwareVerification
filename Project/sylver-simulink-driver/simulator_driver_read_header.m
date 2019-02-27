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

function [ res, header_params ] = simulator_driver_read_header( simcampaign_header_file_name )
%SIMLATOR_DRIVER_READ_HEADER Read header file in order to know simulation campaign parameters
%   simulator_driver_read_header returns 0 and the dictionary if everything is OK, 
%   1 and an empty HashMap otherwise

    import java.io.*;
    import java.util.*;

    % TracesNum is the total number of traces
    % TraceCmd is the campaign command representing a new trace ('L', ...)
    header_params = struct('TracesNum', 0.0,...
                           'TraceCmd', '');
    res = 0;
    [fid, error_message] = fopen(simcampaign_header_file_name, 'r'); 
    if (fid == -1)
        fprintf('Simulink Driver error: %s', error_message);
        res = 1;
    else
        inputLine = fgetl(fid);
        while ischar(inputLine)
            [mat, tok] = regexp(inputLine, '([^=]*)=([^$]*)', 'match', 'tokens');
            if (~isempty(mat))
                % mat is the complete match
                % tok is [\1, \2]
                % \1 is header field
                % \2 is header field corresponding value
                if (strcmpi(tok{1}{1}, 'nTicks'))
                    header_params.TracesNum = str2num(tok{1}{2});
                elseif (strcmpi(tok{1}{1}, 'tickCmdType'))
                    header_params.TraceCmd = tok{1}{2};
                end
            end
            inputLine = fgetl(fid);
        end
        clear mat;
        clear tok;
        fclose(fid);
    end
end

