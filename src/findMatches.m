% This script is a function that will prompt the user for the location of
% the directory containing the wav files, and the location of the directory
% containing the csv files.

% All matching file names are then paired in a csv file called
% Match_Results.csv

function findMatches(wavDirectory, csvDirectory, resultDirectory)
        if (nargin == 0)
            wavDirectory = uigetdir("WAV Folder");
            csvDirectory = uigetdir("CSV Folder");
        end

        wavFiles = dir(fullfile(wavDirectory, '*.wav'));
        csvFiles = dir(fullfile(csvDirectory, '*.csv'));

        matchesDirectory = uigetdir("Where to store match_results?");
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
                    wF = fullfile(wavDirectory, wavFiles(i).name);
                    cF = fullfile(csvDirectory, csvFiles(j).name);
                    % Need a way for these to not overwrite each other, and
                    % to just pop up and click through.
                    
                    if nargin >= 1
                        %figure(figureNo)
                        %figureNo = figureNo + 1;
                        f = figure('Name', wavFiles(i).name);
                        createOverlay(cF, wF);

                        calculateFigureSNR = questdlg('Calculate SNR?', 'SNR', 'Yes', 'No');
                        % Need to be checking for button press.
                        %pause(3)
                        switch calculateFigureSNR
                            case 'Yes'
                                %Calc SNR
                                close(f)
                            case 'No'
                                close(f)
                        end
                    end
                 
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