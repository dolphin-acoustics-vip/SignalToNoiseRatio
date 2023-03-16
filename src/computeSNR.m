function snr = computeSNR(whistle, fs, numFreqBins, numTimeBins, videoStartTime, specVal)
    sym snr;

    nfft = 512;
    overlap = 128;

    whistle_table = readtable(whistle);
    time = whistle_table.("Time_ms_");
    frequency = whistle_table.("PeakFrequency_Hz_");
    advance = nfft - overlap;

    % Create signal box for organization
    min_time = min(time);
    max_time = max(time);
    min_frequency = min(frequency);
    max_frequency = max(frequency);
    
    minSpecBinFreq = floor(min_frequency * numFreqBins / fs + 1);
    minSpecBinTime = floor((min_time - videoStartTime) * fs / advance + 1);
    maxSpecBinFreq = ceil(max_frequency * numFreqBins / fs + 1);
    maxSpecBinTime = ceil((max_time - videoStartTime) * fs / advance + 1);

    runningSum = 0;
    for t = minSpecBinTime : maxSpecBinTime
        verticalEnergyLine = specVal(numFreqBins - maxSpecBinFreq: numFreqBins - minSpecBinFreq, t);
        runningSum = runningSum + sumsqr(verticalEnergyLine);
    end
    
    runningSum = 0;
    eSignal = runningSum / (maxSpecBinTime - minSpecBinTime + 1);
    noiseTime = setdiff(minSpecBinTime:maxSpecBinTime, 1:numTimeBins);
    noiseTimeSamples = randperm(noiseTime, maxSpecBinTime - minSpecBinTime + 1);

    verticalEnergyLines = specVal(numFreqBins - maxSpecBinFreq : numFreqBins - minSpecBinFreq, noiseTimeSamples);
    eNoise = median(verticalEnergyLines);
    snr = 10 * log10(eSignal / eNoise);
end