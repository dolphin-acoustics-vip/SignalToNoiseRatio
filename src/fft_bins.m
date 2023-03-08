function [specBinFreq, specBinTime] = sortFftBins(whistle, nfft, overlap, fs, numFreqBins)
    syms specBinFreq specBinTime;
    whistle_table = readtable(whistle);
    time = whistle_table.("Time_ms_");
    frequency = whistle_table.("PeakFrequency_Hz_");

    min_time = min(time);
    advance = nfft - overlap;
    
    specBinFreq = floor(frequency * numFreqBins / fs + 1);
    specBinTime = floor((time - min_time) * fs / advance + 1);
end
