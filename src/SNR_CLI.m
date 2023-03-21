function SNR_CLI(wavDirectory, csvDirectory, matchesDirectory)
        if (nargin == 0)
            wavDirectory = uigetdir("WAV Folder");
            csvDirectory = uigetdir("CSV Folder");
            matchesDirectory = uigetdir("Where to store match_results?");
        end

        % Creates match_results.csv
        findMatches(wavDirectory, csvDirectory, matchesDirectory)

        file_name = 'Match_Results.csv';
        match_file = fullfile(matchesDirectory, file_name);
        match_table = readtable(match_file,"ReadVariableNames", true);

        % Now go through the matches and first output file names, and then use computeSNR
        for i = 1:height(match_table)
            row = match_table(i,:);
            
            if (not (contains(row.("CSV"), "No matches")))
                wavName = strcat(row.("WAV"), ".wav");
                csvName = strcat(row.("CSV"), ".csv");
                % Get file paths.
                wavPath = fullfile(wavDirectory, wavName);
                csvPath = fullfile(csvDirectory, strcat("pc_", csvName));
    
                disp(strcat(csvName, strcat("   -   ", wavName) ))
    
                computeSNR(csvPath, wavPath)
            end
        end
end