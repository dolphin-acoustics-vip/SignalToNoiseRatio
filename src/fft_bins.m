function [specBinFreq, specBinTime] = sortFftBins(whistle, nfft, fs, numFreqBins, numTimeBins)
    syms specBinFreq specBinTime;
    whistle_table = readtable(whistle);
    time = whistle_table.("Time_ms_");
    frequency = whistle_table.("PeakFrequency_Hz_");
    
    min_time = min(time);
    max_time = max(time);

    min_frequency = min(frequency);
    max_frequency = max(frequency);

    specBinFreq = floor(frequency * numFreqBins / fs + 1);
    specBinTime = floor((time - min_time) * numTimeBins /(max_time - min_time) + 1);
end