function [features] = extract_features(data_in,Fs,num_of_rec)
%extract_features Extracts the features of the input data
%   Analyzes the input data and ouputs the features that are extracted from
%   this data
    
    for index = 1:num_of_rec
        % Determine what word and subject we want to analyze
        [t_vec,f0,frmtns] = VoiceProc(data_in(:,index),Fs,0);

        % Calculating the mean of the pitch and the formants
        f0_mean(index,1) = mean(f0);
        frmtns_mean(index,1:3) = [nanmean(frmtns(:,1)), nanmean(frmtns(:,2)), nanmean(frmtns(:,3))];

        % Calculating the median of the pitch and the formants
        f0_median(index,1) = median(f0);
        frmtns_median(index,1:3) = [nanmedian(frmtns(:,1)), nanmedian(frmtns(:,2)), nanmedian(frmtns(:,3))];

        % Calculating the variance of the pitch and the formants
        f0_var(index,1) = var(f0);
        frmtns_var(index, 1:3) = [nanvar(frmtns(:,1)), nanvar(frmtns(:,2)), nanvar(frmtns(:,3))];

        % Calculating the ratio F1/F2 and its variance
        f1f2_ratio(1:length(frmtns),index) = frmtns(:,1)./frmtns(:,2);
        f1f2_ratio_var(index,1) = nanvar(f1f2_ratio(:,index));
        
        % Calculating the ratio F1/F3 and its variance
        f1f3_ratio(1:length(frmtns),index) = frmtns(:,1)./frmtns(:,3);
        f1f3_ratio_var(index,1) = nanvar(f1f3_ratio(:,index));
        
        % Calculating the ratio F2/F3 and its variance
        f2f3_ratio(1:length(frmtns),index) = frmtns(:,2)./frmtns(:,3);
        f2f3_ratio_var(index,1) = nanvar(f2f3_ratio(:,index));

        % Concatenating the arrays containing the features in one array
        % (features are in the columns)
        features = cat(2,f0_mean,f0_median,f0_var,frmtns_mean,frmtns_median,frmtns_var,f1f2_ratio_var,f1f3_ratio_var,f2f3_ratio_var);
    end
end

