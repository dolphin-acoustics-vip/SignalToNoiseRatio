function snr = computeSNR(contour, wavFile, numFreqBins, numTimeBins, videoStartTime)
    sym snr;

    [~, fs] = audioread(wavFile);
    [spec, ~, ~] = plotSpectrogram(wavFile);
    specVal = abs(spec).^2;
    nfft = 512;
    overlap = 128;

    whistle_table = readtable(contour);
    time = whistle_table.("Time_ms_");
    frequency = whistle_table.("PeakFrequency_Hz_");
    advance = nfft - overlap;

    % Create signal box for organization
    min_time = min(time);
    max_time = max(time);
    min_frequency = min(frequency);
    max_frequency = max(frequency);
    
    minSpecBinFreq = floor(min_frequency * nfft / fs + 1);
    minSpecBinTime = floor((min_time - videoStartTime) * fs / advance + 1);
    maxSpecBinFreq = ceil(max_frequency * nfft / fs + 1);
    maxSpecBinTime = ceil((max_time - videoStartTime) * fs / advance + 1);

    runningSum = 0;
    for t = minSpecBinTime : maxSpecBinTime
        verticalEnergyLine = specVal(numFreqBins - maxSpecBinFreq: numFreqBins - minSpecBinFreq, t);
        runningSum = runningSum + sum(verticalEnergyLine);
    end
    
    %runningSum = 0;
    eSignal = runningSum / (maxSpecBinTime - minSpecBinTime + 1);
    noiseTime = setdiff(minSpecBinTime:maxSpecBinTime, 1:numTimeBins);
    noiseTimeSamples = randperm(noiseTime, maxSpecBinTime - minSpecBinTime + 1);

    verticalEnergyLines = specVal(numFreqBins - maxSpecBinFreq : numFreqBins - minSpecBinFreq, noiseTimeSamples); %(2D array of times and frequencies)
    verticalEnergyLines = sum(verticalEnergyLines, 1); % Length of this array = noiseTimeSamples, if not, try summing across 2nd dimension (to sum frequency).
    eNoise = median(verticalEnergyLines);
    snr = 10 * log10(eSignal / eNoise);
end