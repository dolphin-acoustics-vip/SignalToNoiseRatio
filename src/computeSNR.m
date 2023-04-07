% Compute the Signal-to-Noise ratio given a CSV contour file and WAV audio file
function [SNR_NoiseAcrossFrequencies, SNR_NoiseAcrossTime, min_time, max_time, min_frequency, max_frequency] = computeSNR(contour, wavFile)
    if (nargin ~= 2)
        errordlg("Please provide contour and wav file of the whistle.")
    end

    % Retrieve spectrogram information
    [specVal, ~, ~, fs, nfft, overlap, y] = getSpectrogramOfWav(wavFile);
    
    % Spectral value squared proportional to energy
    specVal = abs(specVal).^2;

    % Getting POSIX time from file name.
    [~, wavName, ~] = fileparts(wavFile);
    time = extractBetween(wavName, 1, 15);
    t = datetime(time,'InputFormat','yyyyMMdd_HHmmss');
    time_init = posixtime(t);
    wavTime = length(y)./fs;

    % Read table and convert time to POSIX standard
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
        signalLine = specVal(minFreqBin:maxFreqBin, t);
        signalSum = signalSum + sum(signalLine);
    end
    
    %%%
    % First SNR calculation - for fixed time
    % The lines being summed can be visualised as a vertical line on a 
    % spectrogram, with it's frequency changing.
    %%%

    % Signal energy for fixed time
    eSignalTime = signalSum / (maxTimeBin - minTimeBin + 1);

    % Line below throws index error
    % Exclude signal time bins to get noise time bins
    % TODO: Talk with Dr. Gillespie about noiseTime 
    % noiseTime = setdiff(1:numTimeBins, minSpecBinTime:maxSpecBinTime);

    % All time bins
    noiseTime = 1:numTimeBins;
    
    % Energy in all time buckets
    noiseTimeLines = specVal(minFreqBin:maxFreqBin, noiseTime);
    noiseTimeLines = sum(noiseTimeLines, 1);

    % Noise "left and right" of the contour.
    % The noise being collected is the energy of all time bins between the
    % min and max frequency bins of the contour.
    % Median to avoid outlier effects
    eNoiseTime = median(noiseTimeLines);
    SNR_NoiseAcrossTime = 10 * log10(eSignalTime / eNoiseTime);

    %%%
    % Second SNR calculation - for fixed frequency
    % The lines being summed can be visualised as a horizontal line on a 
    % spectrogram, with it's time changing.
    %%%

    % Signal energy for fixed frequency
    eSignalFreq = signalSum / (maxFreqBin - minFreqBin + 1);

    % Line below throws index error
    % Exclude signal frequency bins to get noise frequency bins
    % TODO: Talk with Dr. Gillespie about noiseFreq
    % noiseFreq = setdiff(1:nfft/2, minFreqBin:maxFreqBin);

    % All frequency bins
    noiseFreq = 1:nfft/2;

    % Energy in all frequency buckets
    noiseFreqLines = specVal(noiseFreq, minTimeBin:maxTimeBin);
    noiseFreqLines = sum(noiseFreqLines, 2);

    % Noise "above and below" the contour.
    % The noise being collected is the energy of all frequency bins between
    % the max and min time bins.
    % Median to avoid outlier effects
    eNoiseFreq = median(noiseFreqLines);
    SNR_NoiseAcrossFrequencies = 10 * log10(eSignalFreq / eNoiseFreq);
end
