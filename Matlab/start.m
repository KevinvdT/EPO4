clear all; close all;

% Add MatlabWebsocket directory and subdirectories to Matlab path
addpath(genpath('MatlabWebSocket'));

global vehicle;
vehicle = VehicleControl;

controller = Controller('ws://localhost:8080');
web('http://epo4gui.nl')
