classdef Controller < handle
    %CONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        updateTimer
        server
        car
    end
    
    methods
        function obj = Controller(obj)
            %CONTROLLER Construct an instance of this class
            %   Detailed explanation goes here
            obj.server = evalin('base', 'server');
            obj.car = evalin('base', 'car');
            obj.updateTimer = timer();
            obj.updateTimer.ExecutionMode = 'fixedRate';
            obj.updateTimer.Period = 0.1;
            obj.updateTimer.TimerFcn = @(~,~) updateLoop(obj);
            start(obj.updateTimer);
        end
        
        function updateLoop(obj,inputArg)
            % Update carmodel
            updateLoop(obj.car);
            % Send car state to gui via websocket
            sendState(obj.server);
        end

        function delete(obj)
            % Built-in Matlab class method
            % When object of this class will be deleted
            % stop the timer
            stop(obj.updateTimer);
        end
    end
end

