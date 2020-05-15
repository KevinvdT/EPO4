
classdef GuiServer < WebSocketServer
    %ECHOSERVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        conn;
    end
    
    methods
        function obj = GuiServer(varargin)
            %Constructor
            obj@WebSocketServer(varargin{:});
        end

        function sendStateLoop()
            % Receive car data
            carData = EPOCommunications('receive');
            conn.send(carData)
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
            obj.conn = conn;
            obj.sendStateLoop();
        end
        
        function onTextMessage(obj,conn,message)
            disp(message);
            % This function sends an echo back to the client
            conn.send(message); % Echo
        end
        
        function onBinaryMessage(obj,conn,bytearray)
            % This function sends an echo back to the client
            conn.send(bytearray); % Echo
        end
        
        function onError(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onClose(obj,conn,message)
            fprintf('%s\n',message)
        end
    end
end

