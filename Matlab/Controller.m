classdef Controller < WebSocketClient
    % CONTROLLER Controls the websocket connection to the web-based GUI (via the server)
    %   (Detailed explanation goes here)
    
    properties
        updateTimer
        vehicleControl
    end
    
    methods
        function obj = Controller(varargin)
            % Constructor
            obj@WebSocketClient(varargin{:});

            global vehicleControl

            obj.updateTimer = timer();
            obj.updateTimer.ExecutionMode = 'fixedRate';
            obj.updateTimer.Period = 0.2;
            obj.updateTimer.TimerFcn = @(~,~) updateLoop(obj);
            start(obj.updateTimer);

        end

        function sendGuiMessage(obj)
            message = obj.makeGuiMessage();
            obj.send(message);
        end

        function delete(obj)
            stop(obj.updateTimer);
            delete(obj.updateTimer);
            delete@WebSocketClient(obj);
        end

        function updateLoop(obj)
            % disp('Update loop')
            % Send the current (car)data to the GUI (over the websocket)
            sendGuiMessage(obj);
            % global x
            % x = obj;
            global vehicleControl
            % disp('updateLoop')
            update_all(vehicleControl);
        end

    end
    
    methods (Access = protected)

        function message = makeGuiMessage(obj)
            % MAKEGUIMESSAGE   Generates the string to be send to the GUI
            % message = makeGuiMessage() collects the information that needs to be send
            % to the GUI, and outputs a JSON formatted string that is ready
            % to be send to the GUI.
            global vehicleControl

            car = struct;
            car.position = struct;
            car.position.x = vehicleControl.current_x;
            car.position.y = vehicleControl.current_y;
            car.position.theta = vehicleControl.current_yaw * 360 / (2*pi); % Converted from rad to deg
            car.speed = vehicleControl.current_speed;
            car.waypoints = vehicleControl.waypoints;
            car.acceleration = 0;

            % Time since start of run, value null (in JSON) when run not started
            if isempty(vehicleControl.start_t)
                car.timer = [];
            else
                car.timer = toc(vehicleControl.start_t);
            end

            messageStruct = struct('car', car);
            message = jsonencode(messageStruct);
        end

        
        
        % WEBSOCKET FUNCTIONS

        function onOpen(obj,message)
            % Identify as Matlab to the websocket server
            obj.send('{"type": "MATLAB"}');
        end
        
        function onTextMessage(obj,rawMessage)
            fprintf('Message received (TEXT):\n%s\n', rawMessage);
            
            % To access the vehicle-control object
            global vehicleControl

            % Convert message from JSON to Matlab struct
            message = jsondecode(rawMessage);

            % Perform action based on command
            switch message.command

                % Message received to set parameters of the run
                case 'SET_PARAMETERS'
                    % Parameters are in payload struct
                    % See ../Client/src/components/Parameters.js
                    % (class Parameters -> function handleSubmit -> variable messageObject)
                    % for creation of this object/struct 
                    parameters = message.payload;
                    if parameters.startPoint.x < 10
                        vehicleControl.start_x = 10;
                    else
                    vehicleControl.start_x = parameters.startPoint.x;
                    end
                    if parameters.startPoint.y < 10
                        vehicleControl.start_y = 10
                    else
                        vehicleControl.start_y = parameters.startPoint.y;
                    end
                    vehicleControl.start_yaw_deg = parameters.startPoint.theta;
                    vehicleControl.waypoints = [parameters.finalPoint.x parameters.finalPoint.y];
                    vehicleControl.final_x = parameters.finalPoint.x;
                    vehicleControl.final_y = parameters.finalPoint.y;
                
                case 'INITIALIZE_KITT'
                    % Just initialize kitt, but don't start driving
                    initializeKitt(vehicleControl);

                case 'START_KITT'
                    % First initialize kitt (if it hasn't yet), \then start driving
                    if ~vehicleControl.kittHasInitialized
                        initializeKitt(vehicleControl);
                    end
                    startKitt(vehicleControl);
                
                case 'VOICE_COMMAND'
                    % Listens for voice command
                    % If voice command == 2, then initialize and start kitt
                    disp('Ready for voice command');
                    predicted_word = voiceCommand();
                    disp(['Predicted word: ' predicted_word]);
                    if predicted_word == 2
                        initializeKitt(vehicleControl);
                        startKitt(vehicleControl);
                    end

                case 'RESTART_MATLAB'
                    % Restarts everything in Matlab
                    evalin('base', 'start');
                
                % If command not recognized
                otherwise
                    fprintf('Message with unknown command received: %s\n', rawMessage);
            end
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            % This is a standard function of a MatlabWebsocket client
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            % This is a standard function of a MatlabWebsocket client
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % This function simply displays the message received
            % This is a standard function of a MatlabWebsocket client
            fprintf('%s\n',message);
        end

        
    end
end

