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

function simulator_driver_log_signals_save( loggedSignals )
%SIMULATOR_DRIVER_LOG_SIGNALS_SAVE Saves logged signals

    folder = ['signals-' regexprep(datestr(now), '\W', '-')];

    disp(['Saving logged signals to folder ' folder]);

    try
        mkdir(folder);
    catch err
        disp(['The following error has been raised while creating folder ' folder]);
        disp(err.message);
        disp('It was impossible to log signals');
        return;
    end

    loggedKeys = keys(loggedSignals);
    for i=1:length(loggedKeys)
        fig = figure;
        plot(loggedSignals(char(loggedKeys(i))));
        title(loggedKeys(i));
        ylabel('');
        % ylabel(char(loggedKeys(i)));
        % legend('show');
        grid on;
        % print(fig, loggedKeys(i), '-dpng');
        filename = [char(folder) '/' char(loggedKeys(i)) '.png'];
        fprintf('Logging into file %s\n', char(filename));
        try
            saveas(fig, char(filename));
        catch err
            disp('Couldn''t save file for the following error:');
            disp(err.message);
        end
        remove(loggedSignals, loggedKeys(i));
    end
end
