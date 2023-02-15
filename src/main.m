
% reading the wav file.
[samples, fs] = audioread("test_files/20170728_031259_ch05_sel02.wav");

reducedFreq = decimate(samples, 10);
reducedFS = fs / 10;
% make sure the sample rate is double the highest frequency
% - dolphin whistles below 20khz
% need to reduce the frequency of the data
% 44.1khz standard stereo sampling rates - would be the sampling rate of
% wav file - check
% if the sample rate >500khz 


% make a line to overlay over the contours.
window = hamming(512);
nfft = 512;
nooverlap = 128;

spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis')
specVal = spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis');
specVal = abs(specVal);
disp(fs)

% loading all of the contour stats into a matrix.
%encounter = readmatrix("test_files/RoccaContourStats (1).csv");


% reading the csv for the whistle itself.
%whistle_stats = readmatrix("test_files/pc_20170728_031259_ch05_sel02_setteac101_hawaii_ROCCA.csv");

