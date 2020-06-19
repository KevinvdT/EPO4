% Clear everything previously opened in Matlab
clearvars -global;
clear all; close all; clc;

system('start cmd.exe @cmd /k "cd ../Server && node index.js"');

% Add voice commands code to Matlab path
addpath(genpath('voicecommands'));
load('LDA_model_OO_EE_Stop.mat');

% Add MatlabWebsocket directory and subdirectories to Matlab path
addpath(genpath('MatlabWebSocket'));

% Same for carmodel directory
addpath(genpath('carmodel'));

% Initializing the vehicle object
global vehicleControl;
global kitt;
vehicleControl = VehicleControl();

% Initilizing the controller, incl starting the websocket connection
% to the GUI
controller = Controller('ws://localhost:8080');

% Opening the GUI in webbrowser
web('http://epo4gui.nl')