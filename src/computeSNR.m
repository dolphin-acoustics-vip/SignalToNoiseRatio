% Compute the Signal-to-Noise ratio given a CSV contour file and WAV audio file
function [snrHorizontal, snrVertical, min_time, max_time, min_frequency, max_frequency] = computeSNR(contour, wavFile)
    % TODO: Add a default csv file for contour, wav file for audio
    if (nargin == 0)
        wavFile = "";
        contour = "";
    end

    % Retrieve spectrogram information
    [specVal, ~, ~, fs, nfft, overlap, y] = getSpectrogramOfWav(wavFile);
    
    % Spectral value squared proportional to energy
    specVal = abs(spec).^2;

    % Getting posix time from file name.
    [~, wavName, ~] = fileparts(wavFile);
    time = extractBetween(wavName, 1, 15);
    t = datetime(time,'InputFormat','yyyyMMdd_HHmmss');
    time_init = posixtime(t);
    wavTime = length(y)./fs;

    % Read table and process time
    whistle_table = readtable(contour, "ReadVariableNames", true);
    time_ms = (whistle_table.("Time_ms_") - time_init*1000) / 1000;
    frequency = whistle_table.("PeakFrequency_Hz_");
    advance = nfft - overlap;

    % Create signal box for organization
    min_time = min(time_ms);
    max_time = max(time_ms);
    min_frequency = min(frequency);
    max_frequency = max(frequency);
    
    % Organize time and frequency into FFT bins
    minFreqBin = floor(min_frequency * nfft / fs + 1);
    minTimeBin = floor(min_time * fs / advance + 1);
    maxFreqBin = ceil(max_frequency * nfft / fs);
    maxTimeBin = ceil(max_time * fs / advance);
    numTimeBins = (floor((wavTime * fs / advance))) - 1;

    % Sum energy across whistle
    signalSum = 0;
    for t = minTimeBin : maxTimeBin
        fixedFrequencyLine = specVal(minFreqBin:maxFreqBin, t);
        signalSum = signalSum + sum(fixedFrequencyLine);
    end
    
    % Signal energy for fixed time
    eSignalTime = signalSum / (maxTimeBin - minTimeBin + 1);

    % Line below throws index error
    % Exclude signal time bins to get noise time bins
    % TODO: Talk with Dr. Gillespie about noiseTime 
    % noiseTime = setdiff(1:numTimeBins, minSpecBinTime:maxSpecBinTime);

    % All time bins
    noiseTime = 1:numTimeBins;
    
    % Energy in all time buckets
    fixedFrequencyLines = specVal(minFreqBin:maxFreqBin, noiseTime); %(2D array of times and frequencies)
    fixedFrequencyLines = sum(fixedFrequencyLines, 1); % Length of this array = noiseTimeSamples, if not, try summing across 2nd dimension (to sum frequency).

    % Median to avoid outlier effects
    eNoiseTime = median(fixedFrequencyLines);
    snrVertical = 10 * log10(eSignalTime / eNoiseTime);

    % Signal energy for fixed frequency
    eSignalFreq = signalSum / (maxFreqBin - minFreqBin + 1);

    % Line below throws index error
    % Exclude signal frequency bins to get noise frequency bins
    % TODO: Talk with Dr. Gillespie about noiseFreq
    % noiseFreq = setdiff(1:nfft/2, minFreqBin:maxFreqBin);

    % All frequency bins
    noiseFreq = 1:nfft/2;

    % Energy in all frequency buckets
    fixedTimeLines = specVal(noiseFreq, minTimeBin:maxTimeBin);
    fixedTimeLines = sum(fixedTimeLines, 2);

    % Median to avoid outlier effects
    eNoiseFreq = median(fixedTimeLines);
    snrHorizontal = 10 * log10(eSignalFreq / eNoiseFreq);
end
