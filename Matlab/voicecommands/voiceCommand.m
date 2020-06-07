function predicted_word = voiceCommand()
% Words/sounds:
% predicted_word = 0 <-- OO (as in 'doodle')
% predicted_word = 1 <-- EE (as in 'eel')
% predicted_word = 2 <-- Stop

% Call classifier model from workspace
model = evalin('base', 'LDA_model_OO_EE_Stop');

% Mean and standard deviation from the training set of the model
mean_training = [126.141792954594,124.873597437148,213.364647297057,373.260746589399,1398.50623089583,2675.49883144813,375.558624291919,1366.82762249028,2624.01316213124,5786.11225183854,84025.2557452383,87704.7695700556,0.0102988238817056,0.000529311916356902,0.00519040785161118];
std_training = [12.1524464147299,10.5566905267530,1059.75188493494,180.559899260741,693.390364999191,460.843919361420,194.143574401297,711.160411753603,505.729473417292,29659.6082178315,142590.283793156,158055.112920691,0.0142811471182823,0.00133277488172739,0.00639744497911255];

disp('Listening for voice command...');
% Create an audio object and record a word/sound
Fs = 8000;                          % Sample rate of the microphone
recObj = audiorecorder(Fs,16,1);    % Create audio object, 16 bits resolution
recordblocking(recObj, 1);          % Do a 1 second recording (blocking)
Rec = getaudiodata(recObj);         % Rec now contains all of the recording data

% Filtering our signal of interest and extracting the features
Rec_Feat = extract_features(Rec,Fs,1);

% Normalizing the data
Rec_Feat_Norm = (Rec_Feat - mean_training)./std_training;

% Classifying the word using the model
predicted_word = model.predictFcn(Rec_Feat_Norm);

% Print the predicted word
if predicted_word == 0
    disp('You said OO!');
elseif predicted_word == 1
    disp('You said EE!');
elseif predicted_word == 2
    disp('You said Stop!');
end
end