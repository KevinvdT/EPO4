function [y_threshold, t_threshold] = RemoveSilence(y, Fs)
%RemoveSilence Removes silent/irrelevant data from recording
%   Filters out all the samples above a certain amplitude threshold

    dim_y = size(y);        % Determines the dimensions of the vector containing our data
    rows_y = dim_y(1);      % Determines the amount of samples we have (16000 samples for a 2 seconds recording)
    n = 1:rows_y;           % Create a row vector with the amount of samples
    t = n/Fs;               % Convert the samples to the time domain

    % Normalizing the audio signal by subtracting the mean and dividing by the maximum amplitude
    y_normalized = (y - mean(y))/max(y);

%     % Plotting the normalized audio signal
%     figure
%     hold on
%     plot(t, y_normalized),
%     xlabel('Time (s)'), ylabel('Amplitude')
%     title('Recording')
    
    
    % Removing the silent parts from the audio signal
    [y_upper, y_lower] = envelope(y_normalized,100,'rms');  % Create RMS envelope of audio signal with windowlength 100 samples
    
    amp_threshold = 0.1*max(y_upper);                       % Set amplitude threshold for samples
    nonsilent_samples = find(y_upper > amp_threshold);      % Find all samples with amplitude large than threshold
    y_threshold = y_normalized(nonsilent_samples);          % New audio signal from which the silent parts have been filtered out
    n_threshold = 1:length(y_threshold);                    % Create array of samples for time axis
    t_threshold = n_threshold/Fs;                           % Convert samples to seconds
    
%     % Plotting the amplitude threshold filtered audio signal
%     figure
%     hold on
%     plot(t_threshold, y_threshold),
%     xlabel('Time (s)'), ylabel('Amplitude')
%     title('Recording without silence')
end