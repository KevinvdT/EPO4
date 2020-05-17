% Clear all left over variables in (base) workspace
clear;

% Load variabeles for the voice commands into (base) workspace
load('LDA_model_OO_EE_Stop.mat');

% Add Matlab Websockets package to current Matlab path
addpath(genpath('MatlabWebSocket'));

% Add the voice command code to the Matlab path
addpath('voicecommands');

% Make car model object
car = CarPlus;

% Start websockets server on port 30000
server = GuiServer(30000);

pause(1);

% Make and intialize controller object
% this also starts the update loop
controller = Controller;

pause(0.2);

% Open the GUI
system('EPO4GUI.exe');



