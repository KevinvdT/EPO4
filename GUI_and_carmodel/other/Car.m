classdef Car 
    properties
	% status parameters
    position		% reference position at time t0
    maxVelocity = 1;
	velocity = 0;		% init value is needed!
	time
    end

    methods
	function obj = Car(x,v)
	    % constructor (same name as class); returns initialized object
	    if nargin == 0
	        x = 0; v = 0;	% if no input arguments
	    end	
	    obj.position = x;   % (calls set.position; also starts timer)
	    obj.velocity = v;	% calls set.velocity (thus, init value needed)
	end

	function disp(obj)
	    % disp prints the object's values
	    % first update position based on current time and velocity
	    x = obj.position;	% calls get.position, calculates based on current velocity and time
	    v = obj.velocity;
	    t = obj.time;

	    s = sprintf('position: %g',x);
	    disp(s);
	    s = sprintf('velocity: %g',v);
	    disp(s);
	    s = sprintf('time since last update: %g',toc(t));
	    disp(s);
    end
    
    %% Data push and pull

    function output = pull(obj)
        x = obj.position;	% calls get.position, calculates based on current velocity and time
	    v = obj.velocity;
        t = obj.time;
        
        output = struct('x', x);
    end

    function push2(obj, value)
        obj.velocity = value;
    end

    function commandValue = push(obj, string)
        obj.velocity = 5;
        % Get the first character of the string, the type of command
        commandType = string(1);
        % Get the rest of the string, which should be a numeric value
        % @TODO: add error handling
        commandValue = str2double(string(2:end));
        commandValue
        switch commandType
            % Direction
            case 'D'
                direction = 5;
            % (Motor) speed
            case 'M'
                % Map (100, 200) -> (-maxSpeed, +maxSpeed)
                velocity = (commandValue - 150) / 50 * obj.maxVelocity;
                velocity
                obj.velocity = velocity;
                fprintf('why u not work')
                obj.velocity;
        end
    end


    %% Getters and setters

    function obj = set.velocity(obj,v)
        fprintf('test')
	    % first update position based on the old velocity
        x1 = obj.position;		% calls get.position, gives x1, not x0

        obj.position = x1;		% calls set.position; resets timer
        obj.velocity = v;		% then, update velocity
        v
	end

	function x1 = get.position(obj)
	    % when 'position' is queried, calculate current position
	    % (note, cannot update it because 'obj' is not an output param)
            t0 = obj.time;		% t0 = time when last called
            x0 = obj.position;		% x0 = position at time t0
            v = obj.velocity;		% v = velocity at time t0

            T = toc(t0);		% elapsed time (in seconds) since t0
            x1 = x0 + v*T;		% current position based on elapsed time
	end

	function obj = set.position(obj,x)
	    % when 'position' is set, also reset time; leave v the same
	    obj.position = x;		% set current position
        obj.time = tic;             % store current time
	end
    end
end
