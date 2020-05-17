classdef CarPlus < handle
    %CARPLUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
        acceleration
        timestamp
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
            obj.timestamp = tic;
        end

        function driveForward(obj)
            obj.forceAcceleration = 10;
            obj.forceBraking = 0;
        end

        function brake(obj)
            obj.forceAcceleration = 0;
            obj.forceBraking = 10;
        end

        % Legacy?

        function output = pull(obj)
            output = struct('position', obj.position,...
                'velocity', obj.velocity,...
                'acceleration', obj.acceleration);
            updateLoop(obj);
        end

        function obj = push(obj, message)
            % Receives the message from EPOCommunications('transmit', message)
            
            commandType = message(1);
            commandValue = str2double(message(2:end));

            switch commandType
                case 'M'
                    % Converting range (100, 200) to (-10, 10)
                    obj.forceAcceleration = (commandValue - 150) / 50 * 10;
            end

        end
        
        function updateLoop(obj)
            % Calculate passed time since last time
            timePrevious = obj.timestamp;
            deltatime = toc(timePrevious);

            % Update timestamp
            obj.timestamp = tic;

            % Handle very small velocities
            if obj.velocity <= 0.1
                obj.forceBraking = 0;
                % obj.velocity = 0;
            end

            % Compute forces
            forceAcceleration = obj.forceAcceleration;
            forceBraking = obj.forceBraking;
            forceDrag = (obj.bDrag * obj.velocity + obj.cDrag * obj.velocity^2);
            force = forceAcceleration - forceBraking - forceDrag;

            % Update kinematics of the car
            obj.acceleration = force / obj.mass;
            obj.velocity = obj.velocity + obj.acceleration * deltatime;
            obj.position = obj.position + obj.velocity * deltatime;

        end
    end
end

