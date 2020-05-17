clear;
% Add Matlab Websockets package to current Matlab path
addpath(genpath('MatlabWebSocket'));
car = CarPlus;
server = GuiServer(30000);
% Start Matlab based GUI
pause(1);
controller = Controller;



