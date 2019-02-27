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

function [ res, dictionary ] = simulator_driver_read_dictionary( disturbance_dictionary_file_name, debugging_level )
%SIMULATOR_DRIVER_READ_DICTIONARY Reads Dictionary file in order to know disturbances
%   simulator_driver_read_dictionary returns 0 and the dictionary if everything is OK,
%   1 and an empty HashMap otherwise

    import java.io.*;
    import java.util.*;

    dictionary = HashMap;
    res = 0;
    [fid, error_message] = fopen(disturbance_dictionary_file_name, 'r');
    if (fid == -1)
        fprintf('Simulink Driver error: %s', error_message);
        res = 1;
    else
        inputLine = fgetl(fid);
        while ischar(inputLine)
            [mat, tok] = regexp(inputLine, '{([^}]*)}', 'match', 'tokens');
            if (~isempty(mat))
                % (\1, [\3, \4])
                % \1 is input id
                % \3 is input name
                % \4 is value of corresponding disturbance
                % \5 is input name
                % \6 is value of corresponding disturbance
                % ...
                indexes = ((length(tok)-2)/2);
                for ind = 0:indexes-1
                    i = 2 + 2*ind + 1;
                    if (strcmpi(cell2mat(tok{i}), 'NONE'))
                        fault = '0';
                    else
                        fault = cell2mat(tok{i+1});
                    end
                    toAdd{ind+1} = {cell2mat(tok{i}), fault};
                end
                dictionary.put(cell2mat(tok{1}), toAdd);
                %fprintf('%s -> (%s, %s)\n', mat2str(cell2mat(tok{1})), mat2str(cell2mat(tok{3})), mat2str(fault));
                clear toAdd;
            end
            inputLine = fgetl(fid);
        end
        clear mat;
        clear tok;
        fclose(fid);
        % Check that there is a dictionary
        if (dictionary.isEmpty())
            fprintf('Simulink Driver error: no dictionary available');
            res = 1;
        end
    end

    if (debugging_level > 19)
        fprintf('Dictionary:\n');
        it = dictionary.keySet.iterator;
        while it.hasNext
            key = it.next;
            fprintf('%s :', char(key));
            vals = dictionary.get(key);
            for currindex = 1:length(vals)
                vals_i = vals(currindex);
                % disp(vals_i);
                if (length(vals_i) > 1)
                    fprintf(' {%s <- %s}', char(vals_i(1)), char(vals_i(2)));
                else
                    fprintf(' {%s}', char(vals_i(1)));
                end
            end
            fprintf('\n');
        end
        fprintf('\n');
    end
end
