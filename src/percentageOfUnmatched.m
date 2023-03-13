function percentageOfUnmatched(~)
        
        % I'm using this because there are no relative paths in MATLab, and
        % I do not want to hard code any file paths.
        matchesDirectory = uigetdir();
        file_name = 'Match_Results.txt';
        match_file = fullfile(matchesDirectory, file_name);

        % Go through each line and increment either of the variables
        lines = readlines(match_file);
        matches = 0;
        noMatches = 0;

        for i = 1:size(lines)
            currentLine = lines(i, 1);
            if (contains(currentLine, "No matches") == 1)
                noMatches = noMatches + 1;
            elseif (contains(currentLine, "CSV") == 1)
                matches = matches + 1;
            end
        end
        
        disp(matches)
        disp(noMatches)
end