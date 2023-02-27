
function plotCSV(file)
    T = readtable(file);
    % Need a a way to get the time in this function from the file name.
    time_init = posixtime(datetime("2017-07-28 03:12:59"));
    time_ms = (T.("Time_ms_") - time_init*1000) / 1000;
    frequency = T.("PeakFrequency_Hz_");

    % Now plot time against frequency.
    plot(time_ms, frequency)
end