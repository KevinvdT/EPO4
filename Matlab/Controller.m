classdef Controller < WebSocketClient
    %CLIENT Summary of this class goes here
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
            global vehicle
            % position = struct('x', vehicle.current_x, 'y', vehicle.current_y, 'theta', vehicle.current_yaw);
            % speed = vehicle.current_speed;
            % waypoints = vehicle.waypoints;
            % acceleration = 0;
            % car = struct('position', position, 'speed', speed, 'acceleration', acceleration, 'waypoints', waypoints);
            % messageStruct = struct('car', car);
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
            % This function simply displays the message received
            fprintf('%s\n',message);
            obj.send('{"type": "MATLAB"}');
        end
        
        function onTextMessage(obj,rawMessage)
            fprintf('Message received (TEXT):\n%s\n', rawMessage);
            global vehicle
            message = jsondecode(rawMessage);

            switch message.command
                case 'SET_FINAL_POINT'
                    vehicle.waypoints = [message.payload.x, message.payload.y];
                    % typeof(message.payload.x)
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

