function [t_vec,f0,frmtns] = VoiceProc(y,Fs,ShowPlot)
%VoiceProc Processes the input audio signal
%   This function analyzes the audio input signal and outputs its
%   fundamental frequency and formants

L = 20e-3*Fs;        % Convert 20ms window length to number of samples (depends on Fs) (for Fs = 8kHz --> L = 160)
ov = 0.5*L;          % Overlap of 50%


% Remove the silences before and after the signal of interest
[x,t_threshold] = RemoveSilence(y,Fs);


% Spectrogram data of the signal
[S,F,T] = spectrogram(x,hann(L),[],[],Fs);


% Pitch estimation
[f0,t_pitch] = FindPitch(x,Fs);


% Formant estimation on the shortened sigal
[t_vec,frmtns] = FormantsEpo4(x,Fs,L,ov);


% Plot the spectrogram with the features
if ShowPlot == 1
    if      length(x)/Fs >= 1.0                % Factor which scales the time axis of the plots of the spectrogram, fundemental frequency
        t_factor = 1;                          % and the formants correctly depending on the length of the shortened audio signal
    elseif  length(x)/Fs < 1.0
        t_factor = 1e3;
    end
    figure
    hold on
    spectrogram(x,hann(L),[],[],Fs,'yaxis')     % Spectrogram with Hann window of 20ms and 50% overlap (default in spectrogram) so 160-sample Hann window
    plot((t_pitch*t_factor)/Fs,f0/1e3, 'r')     % Plotting the pitch (in red) (time in s or ms vs frequency in kHz)
    plot((t_vec*t_factor),frmtns(:,1)/1e3, 'k') % Plotting the first formant (in black) (time in s or ms vs frequency in kHz)
    plot((t_vec*t_factor),frmtns(:,2)/1e3, 'w') % Plotting the second formant (in white) (time in s or ms vs frequency in kHz)
    plot((t_vec*t_factor),frmtns(:,3)/1e3, 'm') % Plotting the third formant (in magenta) (time in s or ms vs frequency in kHz)
end
end

