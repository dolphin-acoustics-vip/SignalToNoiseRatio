% This script is a function that will prompt the user for the location of
% the directory containing the wav files, and the location of the directory
% containing the csv files.

% All matching file names are then paired in a csv file called
% Match_Results.csv

function findMatches(wavDirectory, csvDirectory, matchesDirectory)
        if (nargin == 0)
            wavDirectory = uigetdir("WAV Folder");
            csvDirectory = uigetdir("CSV Folder");
            matchesDirectory = uigetdir("Where to store match_results?");
        end

        wavFiles = dir(fullfile(wavDirectory, '*.wav'));
        csvFiles = dir(fullfile(csvDirectory, '*.csv'));

        file_name = 'Match_Results.csv';
        match_file = fullfile(matchesDirectory, file_name);
        writelines("CSV,WAV", match_file)

        % Now, match all wav files with csv files of the same dates,
        % channel and selection.
        for i = 1:(length(wavFiles))
            wavN = wavFiles(i).name;
            % Get rid of .wav
            wavN = erase(wavN, ".wav");
            
            for j = 1:(length(csvFiles))
                csvN = csvFiles(j).name;
                %Get rid of parts of the name that is not needed to
                %determine equality between csv and wav file names.
                csvN = erase(csvN, ".csv");
                csvN = erase(csvN, "pc_");
    
                matches = contains(csvN, wavN);
                if (matches == 1)
                    firstCol = strcat(csvN, ",");
                    secCol = wavN;
                    writelines(strcat(firstCol, secCol), match_file, WriteMode="append")
                    break
                elseif ((matches == 0) && (j == length(csvFiles)))
                    if (contains(wavN, "Copy") == 0)
                        writelines(strcat("No matches,", wavN), match_file, WriteMode="append")
                    end
                end
            end

        end
end