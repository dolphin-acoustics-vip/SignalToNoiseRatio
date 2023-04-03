# SignalToNoiseRatio
There are two methods for using the Signal to Noise Ratio (SNR) program.
  This program works by prompting the user for three directories: 
    One containing the whistle clips (WAV format - this is currently stored in RAVEN wave file clips under current  storage conventions on the OneDrive).
    Another containing the contours, represented as CSV files of the contour's frequency at a given point in time. (this is currently stored in ROCCA the .csv files under     current  storage conventions on the OneDrive).
    The third directory is the directory to which the user wishes to stored the results of the SNRs of all whistles in the first two directories.
        "SNR_Results.csv" is the file in which the results of all computations will be stored.

The scripts/functions for running the program is in src.

The computeSNR script/function can be used to return the SNR of a single whistle (given the matching whistle clip and frequency contour file).

## Using the GUI:
  - Open the SNR_GUI.mlapp file. This will prompt for three directory paths.
  - When the GUI is running, you can flick through each whistle's spectrogram, and the overlay of the contour and signal box will be shown.
 
## Using the CLI:
    - SNR_CLI("<wav_directory>", "<csv_directory>", "<results_directory>")
