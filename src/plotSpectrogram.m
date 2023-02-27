% This file holds the method for plotting the spectrogram onto the GUI.

function plotSpectrogram(file)
    [samples, fs] = audioread(file);

    % Decimating, so that the sample rate is double the highest frequency -
    % Nyquist's Theorem.
    reducedFreq = decimate(samples, 10);
    reducedFS = fs / 10;
    
    % Arguments for the spectrogram function.
    window = hamming(512);
    nfft = 512;
    nooverlap = 128;

    % This usually opens in its own window, but how to have this go onto
    % the GUI?
    spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis')
end

% make sure the sample rate is double the highest frequency
% - dolphin whistles below 20khz
% need to reduce the frequency of the data
% 44.1khz standard stereo sampling rates - would be the sampling rate of
% wav file - check
% if the sample rate >500khz 
 % This file holds the method for plotting the spectrogram onto the GUI.

function plotSpectrogram(file)
    [samples, fs] = audioread(file);

    % Decimating, so that the sample rate is double the highest frequency -
    % Nyquist's Theorem.
    reducedFreq = decimate(samples, 10);
    reducedFS = fs / 10;
    
    % Arguments for the spectrogram function.
    window = hamming(512);
    nfft = 512;
    nooverlap = 128;

    % This usually opens in its own window, but how to have this go onto
    % the GUI?
    spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis')
end

% make sure the sample rate is double the highest frequency
% - dolphin whistles below 20khz
% need to reduce the frequency of the data
% 44.1khz standard stereo sampling rates - would be the sampling rate of
% wav file - check
% if the sample rate >500khz 
