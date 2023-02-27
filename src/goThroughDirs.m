% This script is a function that will prompt the user for the location of
% the directory containing the wav files, and the location of the directory
% containing the csv files.

% Once the directory locations are obtained, the matching csv file is found
% for the given wav file, a dialog box of the plot is shown

% Figure out a way to cycle through all of the wav files
% Also, give percentage of number of wav files matched, compared to how
% many csv files there were.

function goThroughDirs(gui)
    if nargin < 1
        wavDirectory = uigetdir();
        csvDirectory = uigetdir();

        wavFiles = dir(strcat(wavDirectory));
        disp(wavFiles)
        csvFiles = dir(strcat(csvDirectory));

        % Now, match all wav files with csv files of the same dates,
        % channel and selection.
        L = length(wavFiles);
        disp("Length")
        disp(L)
        disp("loop -----")
        for i=1:L
            wavFile = wavFiles(1:i);
            disp(wavFile)
            [~,wavName,~] = fileparts(wavFile);
            disp(wavName)
            disp("===")
            % Do some stuff
        end

        % Fastest way of matching file names?
        % Store them both in arrays

    elseif nargin == 1
        disp("GUI")
    end
end