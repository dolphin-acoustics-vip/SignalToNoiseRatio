function [snr, min_time, max_time, min_frequency, max_frequency] = computeSNR(contour, wavFile)
    if (nargin == 0)
        wavFile = "C:\Users\Samin\Desktop\SNR\src\test_files\wav\20170728_031259_ch05_sel02.wav";
        contour = "C:\Users\Samin\Desktop\SNR\src\test_files\csv\pc_20170728_031259_ch05_sel02_setteac101_hawaii_ROCCA.csv";
    end
    [y, fs] = audioread(wavFile);

    % Decimating based on current sample rate of given wav file.
    d = round(fs / 50000);
    d = max(d, 1);
    if d > 1
        y = decimate(y, d);
        fs = fs / d;
        % Write sample rates to the csv file
    end

    nfft = 512;
    overlap = 128;
    %[spec, ~, ~] = plotSpectrogram(y, fs);
    spec = spectrogram(y, hamming(nfft), overlap, nfft, fs, 'yaxis');
    % plots spectrogram to figure.
    %spectrogram(y, hamming(nfft), overlap, nfft, fs, 'yaxis');
    specVal = abs(spec).^2;

    % Getting posix time based on file name.
    [~, wavName, ~] = fileparts(wavFile);
    time = extractBetween(wavName, 1, 15);
    t = datetime(time,'InputFormat','yyyyMMdd_HHmmss');
    time_init = posixtime(t);
    wavTime = length(y)./fs;

    whistle_table = readtable(contour, "ReadVariableNames", true);

    time_ms = (whistle_table.("Time_ms_") - time_init*1000) / 1000;
    disp(time_ms)
    frequency = whistle_table.("PeakFrequency_Hz_"); % maybe divide by 1000
    advance = nfft - overlap;

    % Create signal box for organization
    min_time = min(time_ms);
    max_time = max(time_ms);
    min_frequency = min(frequency);
    max_frequency = max(frequency);
    
    minSpecBinFreq = floor(min_frequency * nfft / fs + 1);
    minSpecBinTime = floor(min_time * fs / advance + 1);
    maxSpecBinFreq = ceil(max_frequency * nfft / fs);
    maxSpecBinTime = ceil(max_time * fs / advance);
    numTimeBins = (floor((wavTime * fs / advance))) - 1;

    runningSum = 0;
    for t = minSpecBinTime : maxSpecBinTime
        verticalEnergyLine = specVal(minSpecBinFreq:maxSpecBinFreq, t);
        runningSum = runningSum + sum(verticalEnergyLine);
    end
    
    eSignal = runningSum / (maxSpecBinTime - minSpecBinTime + 1);
    %noiseTime = setdiff(1:numTimeBins, minSpecBinTime:maxSpecBinTime);
    noiseTime = 1:numTimeBins;
    
    verticalEnergyLines = specVal(minSpecBinFreq:maxSpecBinFreq, noiseTime); %(2D array of times and frequencies)
    verticalEnergyLines = sum(verticalEnergyLines, 1); % Length of this array = noiseTimeSamples, if not, try summing across 2nd dimension (to sum frequency).

    eNoise = median(verticalEnergyLines);
    snr = 10 * log10(eSignal / eNoise);
end
