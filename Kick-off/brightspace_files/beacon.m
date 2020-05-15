% Example script:
%
% Create a class named beacon, placed in file 'beacon.m' (same name as class)
% This demonstrates a simple beacon; showing input range validation
%
% Usage:
% s = beacon		% create a beacon
% s.button = true	% switch 'on'
% s.code = 2		% set code, integer between 1 and 5
% s			% show status


classdef beacon 
    properties
	button logical = false;	% implement a switch; initial value is off
	code 			% we want this to be integer between 1 and 5
    end
    methods
	function obj = beacon(a,c)
	    % constructor (same name as class); returns initialized object
	    if nargin == 0
	        a = false;	% default value for a if not specified
	    end	
	    if nargin <= 1
	        c = 1;		% default value for c if not specified
	    end	
	    obj.button = a;
	    obj.code = c;	% this will call set.code
	end
	function disp(obj)
	    % disp is called when we ask to print the object's values
	    % it can be used to manipulate the presentation
	    a = obj.button;
	    c = obj.code;
	    if a
	       aa = 'on';
	    else
	       aa = 'off';
	    end
	    s = sprintf('button: %s',aa);
	    disp(s);
	    s = sprintf('code: %g',c);
	    disp(s);
	end
	function obj = set.code(obj,c);
	    % set value for the code property
	    % first, do validity checking of c prior to assignment
	    if ((c ~= uint8(c)) || (c>5) || (c<1))
		error('code should be integer between 1 and 5');
	    end
	    obj.code = c;	% make the actual assignment
	end
	function c = get.code(obj);
	    % get value for the code property
	    % this function is called whenever we ask for obj.code
	    % it is not really needed in this example
	    c = obj.code;
	end
    end
end
