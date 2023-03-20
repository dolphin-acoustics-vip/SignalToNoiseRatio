function [snr, min_time, max_time, min_frequency, max_frequency] = computeSNR(contour, wavFile)
    [y, fs] = audioread(wavFile);
    [spec, ~, ~] = plotSpectrogram(wavFile);
    specVal = abs(spec).^2;
    nfft = 512;
    overlap = 128;

    [~, wavName, ~] = fileparts(wavFile);
    time = extractBetween(wavName, 1, 15);
    t = datetime(time,'InputFormat','yyyyMMdd_HHmmss');
    time_init = posixtime(t);
    wavTime = length(y)./fs;

    whistle_table = readtable(contour);
    %disp(time_init);
    %disp((min(whistle_table.("Time_ms_")) - time_init * 1000)/1000);

    time_ms = (whistle_table.("Time_ms_") - time_init*1000) / 1000;
    frequency = whistle_table.("PeakFrequency_Hz_"); % maybe divide by 1000
    advance = nfft - overlap;

    % Create signal box for organization
    min_time = min(time_ms);
    max_time = max(time_ms);
    min_frequency = min(frequency);
    max_frequency = max(frequency);
    
    minSpecBinFreq = floor(min_frequency * nfft * 10 / fs + 1);
    minSpecBinTime = floor(min_time * fs / advance / 10 + 1);
    maxSpecBinFreq = ceil(max_frequency * nfft * 10 / fs + 1);
    maxSpecBinTime = ceil(max_time * fs / advance / 10 + 1);
    numTimeBins = floor((wavTime * fs / advance + 1)/10);

    runningSum = 0;
    for t = minSpecBinTime : maxSpecBinTime
        verticalEnergyLine = specVal(minSpecBinFreq:maxSpecBinFreq, t);
        runningSum = runningSum + sum(verticalEnergyLine);
    end
    
    %runningSum = 0;
    eSignal = runningSum / (maxSpecBinTime - minSpecBinTime + 1);
    noiseTime = setdiff(1:numTimeBins, minSpecBinTime:maxSpecBinTime);
    
    verticalEnergyLines = specVal(minSpecBinFreq:maxSpecBinFreq, noiseTime); %(2D array of times and frequencies)
    verticalEnergyLines = sum(verticalEnergyLines, 1); % Length of this array = noiseTimeSamples, if not, try summing across 2nd dimension (to sum frequency).

    eNoise = median(verticalEnergyLines);
    snr = 10 * log10(eSignal / eNoise);
    signalBox = [min_time, max_time, min_frequency, max_frequency];
end
