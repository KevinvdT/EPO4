% Example script:
%
% Create a class named car, placed in file 'car.m' (use same name as class)
% Usage:
% kitt = car		% create a new car
% kitt.velocity = 3	% give it some speed
% kitt			% update position based on velocity before displaying
% kitt.position		% also calculates position
%
% to add:
%   property value validation; range restrictions
%
% Alle-Jan van der Veen, TU Delft, 24 Apr 2020


classdef car 
    properties
	% status parameters
	position		% reference position at time t0
	velocity = 0;		% init value is needed!
	time
    end

    methods
	function obj = car(x,v)
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

	function obj = set.velocity(obj,v)
	    % first update position based on the old velocity
            x1 = obj.position;		% calls get.position, gives x1, not x0

            obj.position = x1;		% calls set.position; resets timer
	    obj.velocity = v;		% then, update velocity
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
