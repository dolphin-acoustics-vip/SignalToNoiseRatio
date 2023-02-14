
% reading the wav file.
[samples, fs] = audioread("test_files/20170728_031259_ch05_sel02.wav");

window = hamming(512);
nfft = 2048;
nooverlap = 256;

spectrogram(samples, window, nooverlap, nfft, fs, 'yaxis')

disp(fs)

% loading all of the contour stats into a matrix.
%encounter = readmatrix("test_files/RoccaContourStats (1).csv");


% reading the csv for the whistle itself.
%whistle_stats = readmatrix("test_files/pc_20170728_031259_ch05_sel02_setteac101_hawaii_ROCCA.csv");

