% Compute the Signal-to-Noise ratio given a CSV contour file and WAV audio file
function [snrHorizontal, snrVertical, min_time, max_time, min_frequency, max_frequency] = computeSNR(contour, wavFile)
    % TODO: Add a default csv file for contour, wav file for audio
    if (nargin == 0)
        wavFile = "";
        contour = "";
    end

%     [y, fs] = audioread(wavFile);
% 
%     % Decimating based on current sample rate of given wav file.
%     d = round(fs / 50000);
%     d = max(d, 1);
%     if d > 1
%         y = decimate(y, d);
%         fs = fs / d;
%         % Write sample rates to the csv file
%     end
% 
%     nfft = 512;
%     overlap = 128;
%     spec = spectrogram(y, hamming(nfft), overlap, nfft, fs, 'yaxis');

    [specVal, ~, ~, fs, nfft, overlap, y] = getSpectrogramOfWav(wavFile);

    % Spectral value squared is proportional to energy
    specVal = abs(specVal).^2;

    % Getting posix time based on file name.
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
    runningSum = 0;
    for t = minTimeBin : maxTimeBin
        verticalEnergyLine = specVal(minFreqBin:maxFreqBin, t);
        runningSum = runningSum + sum(verticalEnergyLine);
    end
    
    % Ask Dr. Gillespie about noiseTime
    eSignal = runningSum / (maxTimeBin - minTimeBin + 1);
    %noiseTime = setdiff(1:numTimeBins, minTimeBin:maxTimeBin);
    noiseTime = 1:numTimeBins;
    
    % Energy in each time bucket
    verticalEnergyLines = specVal(minFreqBin:maxFreqBin, noiseTime); %(2D array of times and frequencies)
    verticalEnergyLines = sum(verticalEnergyLines, 1); % Length of this array = noiseTimeSamples, if not, try summing across 2nd dimension (to sum frequency).

    % Ask Dr. Gillespie if (eSignal + eNoise)/eNoise is any better?
    eNoise = median(verticalEnergyLines);
    snrVertical = 10 * log10(eSignal / eNoise);

    runningSum = 0;
    for f = minFreqBin : maxFreqBin
        horizontalEnergyLine = specVal(f, minTimeBin:maxTimeBin);
        runningSum = runningSum + sum(horizontalEnergyLine);
    end

    eSignal = runningSum / (maxFreqBin - minFreqBin + 1);
    %noiseFreq = setdiff(1:nfft, minFreqBin:maxFreqBin);
    noiseFreq = 1:nfft/2;

    horizontalEnergyLines = specVal(noiseFreq, minTimeBin:maxTimeBin);
    horizontalEnergyLines = sum(horizontalEnergyLines, 2);

    eNoise = median(horizontalEnergyLines);
    snrHorizontal = 10 * log10(eSignal / eNoise);
end
