% This file will hold a function to create an overlay with the given
% spectrogram and csv.

function createOverlay(csvFile, wavFile)
    plotSpectrogram(wavFile)
    hold on
    
    [~,csvName,~] = fileparts(csvFile);
    [~,wavName,~] = fileparts(wavFile);

    % shared is date, channel (? - not always in name) and selection.
    % csv file has extra - relevant parts is after 'pc_'

    % check that wavName matches pc_wavName_(encoutner name - irrelevant) - this being
    % csvName
    expression = strcat("pc_", wavName, "\w*");
    startIndex = regexp(csvName,expression, 'once');
    % if start index is an empty array, the file names do not match.
    matches = not(isempty(startIndex));

    if matches
        time = extractBetween(wavName, 1, 15);
        t = datetime(time,'InputFormat','yyyyMMdd_HHmmss');
        time_init = posixtime(t);

        T = readtable(csvFile);
        frequency = T.("PeakFrequency_Hz_") / 1000;
        time_ms = (T.("Time_ms_") - time_init*1000) / 1000;
        
        x = time_ms;
        y = frequency;
        plot(x, y, 'k');
        hold off
    else
        % Dialog box
        msgbox("Names do not match.")
    end
end