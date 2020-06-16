% Clear everything previously opened in Matlab
clear all; close all; clc;

% Add MatlabWebsocket directory and subdirectories to Matlab path
addpath(genpath('MatlabWebSocket'));

% Initializing the vehicle object
global vehicle;
vehicle = VehicleControl;
vehicle.current_x = 50;
vehicle.current_y = 200;

% Initilizing the controller, incl starting the websocket connection
% to the GUI
controller = Controller('ws://localhost:8080');

% Opening the GUI in webbrowser
%web('http://epo4gui.nl')
