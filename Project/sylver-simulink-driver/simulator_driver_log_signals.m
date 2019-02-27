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

function simulator_driver_log_signals( simOut, loggedSignals )
%simulator_driver_log_signals() Updates signal map with new signals

    logsout = simOut.get('logsout');
    logsout.unpack('all');
    los = keys(loggedSignals);
    lot = [];
    for i=1:length(los)
        try
            eval(['tmp = timeseries(' char(los(i)) '.Data, ' char(los(i)) '.Time);']);
            lot{i} = tmp;
            clear tmp;
        catch err
            fprintf('Signal ''%s'' not found. The logged signal is likely to be composed by many signals. Try and log single signals separately.\n', char(los(i)));
            disp(err.message);
        end
    end
    newSignals = containers.Map(los, lot);
    for i=1:length(los)
        loggedSignals(char(los(i))) = append(loggedSignals(char(los(i))), newSignals(char(los(i))));
        remove(newSignals, char(los(i)));
    end
    clear los lot newSignals logsout;
end
