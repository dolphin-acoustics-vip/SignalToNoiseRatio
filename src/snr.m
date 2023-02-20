[samples, fs] = audioread("test_files/20170728_031259_ch05_sel02.wav");
time_init = posixtime(datetime("2017-07-28 03:12:59"));

% Read table, get frequency and pressure
T = readtable("pc_20170728_031259_ch05_sel02_setteac101_hawaii_ROCCA.xlsx");
frequency = T.("PeakFrequency_Hz_") / 1000;
pressure = T.("WindowRMS");
time_ms = (T.("Time_ms_") - time_init*1000) / 1000;

reducedFreq = decimate(samples, 10);
reducedFS = fs / 10;
window = hamming(512);
nfft = 512;
nooverlap = 128;

spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis');
%specVal = spectrogram(reducedFreq, window, nooverlap, nfft, reducedFS, 'yaxis');
%specVal = abs(specVal);

hold on
x = time_ms;
y = frequency;
plot(x, y, 'k');
hold off

%{
% STUFF ENDS HERE

amplitude = [];

% Bunch rows with same frequency together
% Calculate the total pressure for given frequency
uniqueFreq = unique(frequency);
for i=1:length(uniqueFreq)
    % x = T(T(:, "PeakFrequency_Hz_") == uniqueFreq(i), :);
    TByFrequency = T(T.PeakFrequency_Hz_ == uniqueFreq(i), :);
    pressure = sum(TByFrequency.("WindowRMS"));
    amplitude(end + 1) = pressure;
    % T(any(T.("PeakFrequency_Hz_") == uniqueFreq(i), :));
end

% plot amplitude vs frequency
% plot(uniqueFreq, amplitude);

begin = -1;
finish = -1;

% Find point where program starts increasing
for i=1:length(amplitude)-1
    prevAmplitude = amplitude(end - i + 1);
    nextAmplitude = amplitude(end - i);
    if(nextAmplitude > prevAmplitude)
        begin = i;
        break
    end
end

% Find peak
for i=begin:length(amplitude)-1
    prevAmplitude = amplitude(end - i + 1);
    nextAmplitude = amplitude(end - i);
    if(nextAmplitude < prevAmplitude)
        finish = i;
        break
    end
end

% Use decibel formula
p1 = amplitude(end - finish + 1) - amplitude(end - begin + 1);
p2 = max(amplitude) - min(amplitude);
dB = 20*log10(p1/p2);
disp(dB);

% Import the csv file and use energy column for pressure
% Treat the csv file like a test
% Use root of sum of squares to get total energy (or Amplitude)
% Graph frequency vs amplitude
% Point out the outlying peak (that's the whistle)
% Take the amplitude difference of signal and noise
% Do 20*log(signal amplitude / noise amplitude)
%}
