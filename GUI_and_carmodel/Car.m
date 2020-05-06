classdef Car
    properties %(Access = private)
        powerOn = false;
        time;
        position = struct('x', 10, 'y', 20); % in centimeters
        orientation; % in degrees, 0 is twaalf uur
        speed; % cm/sec
        maxSpeed = 5;
        direction;
    end

    methods
        function obj = Car(x, v)
            obj.reset(0, 0);
        end
        function reset(obj, x, v)
            if nargin == 0 % if no input arguments
                x = 0;
                v = 0;
            end
            obj.powerOn = true;
            obj.position.x = x;
            obj.orientation = 0;
            obj.speed = v;
            obj.direction = 0;
            obj.time = tic;
        end
        function updatePosition(obj)
            deltaTime = toc(obj.time);
            deltaTime
            obj.position.x = obj.position.x + obj.speed * deltaTime;
            obj.time = tic;
        end
        function push(obj, string)
            obj.updatePosition();
            % Get the first character of the string, the type of command
            commandType = string(1)
            % Get the rest of the string, which should be a numeric value
            % @TODO: add error handling
            commandValue = str2num(string(2:end));
            switch commandType
                % Direction
                case 'D'
                    obj.direction = commandValue;
                % (Motor) speed
                case 'M'
                    speed = (commandValue - 150) / 50 * obj.maxSpeed
                    obj.speed = commandValue;
            end
            deltaTime = toc(obj.time);
            obj.position.x = obj.position.x + obj.speed * deltaTime;
        end
        function data = pull(obj)
            obj.updatePosition();
            data = struct('powerOn', true, 'x', obj.position.x);
        end
    end
end