clear all; close all; clc;

% Add MatlabWebsocket directory and subdirectories to Matlab path
addpath(genpath('MatlabWebSocket'));

global vehicle;
vehicle = VehicleControl;
vehicle.current_x = 50;
vehicle.current_y = 200;

controller = Controller('ws://localhost:8080');
%web('http://epo4gui.nl')
