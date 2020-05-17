classdef CarPlus < handle
    %CARPLUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
        acceleration
        deltatime = 0.05;
        mass = 13;
        forceAcceleration
        forceBraking
        bDrag = 0.0015;
        cDrag = 0.02;
    end
    
    methods
        function obj = CarPlus(obj)
            %CARPLUS Construct an instance of this class
            %   Detailed explanation goes here
            obj.position = 0;
            obj.velocity = 0;
            obj.acceleration = 0;
            obj.forceAcceleration = 0;
            obj.forceBraking = 0;

        end

        function output = pull(obj)
            output = struct('position', obj.position);
            updateLoop(obj);
        end

        function obj = push(obj, message)
            % Receives the message from EPOCommunications('transmit', message)
            
            commandType = message(1);
            commandValue = str2double(message(2:end));

            switch commandType
                case 'M'
                    % Converting range (100, 200) to (-50, 50)
                    obj.forceAcceleration = (commandValue - 150) / 50 * 50;
            end

        end
        
        function updateLoop(obj)
            forceAcceleration = obj.forceAcceleration;
            forceBraking = obj.forceBraking;
            forceDrag = (obj.bDrag * obj.velocity + obj.cDrag * obj.velocity^2);
            force = forceAcceleration - forceBraking - forceDrag;

            obj.acceleration = force / obj.mass;
            obj.velocity = obj.velocity + obj.acceleration * obj.deltatime;
            obj.position = obj.position + obj.velocity * obj.deltatime;

        end
    end
end

