% Clear everything previously opened in Matlab
clearvars -global;
clear all; close all; clc;

% Add MatlabWebsocket directory and subdirectories to Matlab path
addpath(genpath('MatlabWebSocket'));

% Same for carmodel directory
addpath(genpath('carmodel'));

% Initializing the vehicle object
global vehicleControl;
global kitt;
vehicleControl = VehicleControl();
% vehicleControl.current_x = 50;
% vehicleControl.current_y = 200;

% Initilizing the controller, incl starting the websocket connection
% to the GUI
controller = Controller('ws://localhost:8080');

% Opening the GUI in webbrowser
%web('http://epo4gui.nl')


