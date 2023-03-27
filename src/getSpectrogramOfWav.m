% This function returns a spectrogram based on the wav file given.
% The GUI needs 3 return values from the spectrogram function available in
% MATLab, and computeSNR needs one return value from the same function.

% This function will decimate the wav file, based on it's sample rate, and
% return values from the resulting spectrogram.

function [s, f, t, fs, nfft, overlap, samples] = getSpectrogramOfWav(wavFile)
    % Reading the wav file. 
    [samples, fs] = audioread(wavFile);

    % Decimating based on current sample rate of given wav file.
    d = round(fs / 50000);
    d = max(d, 1);
    if d > 1
        samples = decimate(samples, d);
        fs = fs / d;
    end

    % Setting up the values to be used in the spectrogram function.
    nfft = 512;
    window = hamming(nfft);
    overlap = 128;
    [s, f, t] = spectrogram(samples, window, overlap, nfft, fs, 'yaxis');
end