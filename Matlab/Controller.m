classdef Controller < WebSocketClient
    % CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        updateTimer
    end
    
    methods
        function obj = Controller(varargin)
            %Constructor
            obj@WebSocketClient(varargin{:});
            obj.updateTimer = timer();
            obj.updateTimer.ExecutionMode = 'fixedRate';
            obj.updateTimer.Period = 0.1;
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

    end
    
    methods (Access = protected)
        function updateLoop(obj)
            % Send the current (car)data to the GUI (over the websocket)
            obj.sendGuiMessage();
        end

        function message = makeGuiMessage(obj)
            % MAKEGUIMESSAGE   Generates the string to be send to the GUI
            % message = makeGuiMessage() collects the information that needs to be send
            % to the GUI, and outputs a JSON formatted string that is ready
            % to be send to the GUI.
            global vehicle

            car = struct;
            car.position = struct;
            car.position.x = vehicle.current_x;
            car.position.y = vehicle.current_y;
            car.position.theta = vehicle.current_yaw;
            car.speed = vehicle.current_speed;
            car.waypoints = vehicle.waypoints;
            car.acceleration = 0;

            messageStruct = struct('car', car);
            message = jsonencode(messageStruct);
        end

        
        
        % WEBSOCKET FUNCTIONS

        function onOpen(obj,message)
            % fprintf('%s\n',message);

            % Identify as Matlab to the websocket server
            obj.send('{"type": "MATLAB"}');
        end
        
        function onTextMessage(obj,rawMessage)
            fprintf('Message received (TEXT):\n%s\n', rawMessage);
            
            % To access the vehicle-control object
            global vehicle

            % Convert message from JSON to Matlab struct
            message = jsondecode(rawMessage);

            % Perform action based on command
            switch message.command

                % Message received to set parameters of the run
                case 'SET_PARAMETERS'
                    parameters = message.payload;
                    vehicle.current_x = parameters.startPoint.x;
                    vehicle.current_y = parameters.startPoint.y;
                    vehicle.waypoints = [parameters.finalPoint.x, parameters.finalPoint.y];

                % If command not recognized
                otherwise
                    fprintf('Message with unknown command received: %s\n', rawMessage);
            end
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end

        
    end
end

