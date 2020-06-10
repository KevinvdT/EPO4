clear all; close all;

global vehicle;
vehicle = VehicleControl;

controller = Controller('ws://localhost:8080');
