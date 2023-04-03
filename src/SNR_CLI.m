% This function is used to calculate the SNR of of all matched files
% between two given directories containing wav and csv files.

% The results of this is stored in another user-specified directory, under
% file name 'SNR_Results.csv'
function SNR_CLI(wavDirectory, csvDirectory, matchesDirectory)

        % If no arguments/incorrect number of arguments provided, 
        % prompt user for directories.
        if (nargin ~= 3)
            wavDirectory = uigetdir("WAV Folder");
            csvDirectory = uigetdir("CSV Folder");
            matchesDirectory = uigetdir("Where to store match_results?");
        end

        % Creates match_results.csv
        findMatches(wavDirectory, csvDirectory, matchesDirectory)
        % Make snr results file.
        file_name = 'SNR_Results.csv';
        snr_file = fullfile(matchesDirectory, file_name);
        writelines("Contour,Clip,SNR_Fixed_Time, SNR_Fixed_Frequency", snr_file, "WriteMode","overwrite");

        % Getting the matches between the wav and csv files, and storing
        % them in a table, so that each row can be accessed and the SNR of
        % each match can be calculated.
        file_name = 'Match_Results.csv';
        match_file = fullfile(matchesDirectory, file_name);
        match_table = readtable(match_file,"ReadVariableNames", true);

        % Now go through the matches and first output file names, and then use computeSNR
        for i = 1:height(match_table)
            row = match_table(i,:);
            
            % If there is a match for the wav file, calculate SNR.
            if (not (contains(row.("CSV"), "No matches")))
                
                % Get file name, need to concatenate file extensions to the
                % names from the table row.
                wavName = strcat(row.("WAV"), ".wav");
                csvName = strcat(row.("CSV"), ".csv");
                % Get file paths of the matched wav and csv file.
                wavPath = fullfile(wavDirectory, wavName);
                csvPath = fullfile(csvDirectory, strcat("pc_", csvName));
    
                % displaying wav and csv for debugging purposes.
                %disp(strcat(csvName, strcat("   -   ", wavName) ))
    
                % Getting the SNR by using computeSNR.
                [snrFreq, snrTime, ~, ~, ~, ~] = computeSNR(csvPath, wavPath);
                % Write SNR, and the wav name, to the SNR results csv file.
                cName = strcat(strcat("pc_", csvName), ",");
                allNames = strcat(strcat(cName, wavName), ",");
                snrVals = strcat( strcat( string(snrTime), "," ), string(snrFreq) );
                writelines(strcat(allNames, snrVals), snr_file, "WriteMode","append");
            end
        end
end