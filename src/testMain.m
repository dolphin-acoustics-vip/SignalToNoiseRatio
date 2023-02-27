[wavF, wavP] = uigetfile("*.wav", "WAV Selection");
[csvF, csvP] = uigetfile("*.csv", "CSV Selection");

csvFile = fullfile(csvP, csvF);
wavFile = fullfile(wavP, wavF);

createOverlay(csvFile, wavFile)