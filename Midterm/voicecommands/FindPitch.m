function [f0,t_pitch] = FindPitch(threshold_data, Fs, L, ov)
%FindPitch Function that finds the pitch of our audio signal
%   Determines the pitch of each 20ms Hann window (with 50% overlap) of the
%   spectrogram

    [f0,t_pitch] = pitch(threshold_data, Fs);
end