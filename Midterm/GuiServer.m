
classdef GuiServer < WebSocketServer
    %GuiServer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        conn;
        isOpen;
    end
    
    methods
        function obj = GuiServer(varargin)
            
            %Constructor
            obj@WebSocketServer(varargin{:});
            obj.isOpen = false;
        end

        function sendStateLoop(obj)
            % Receive car data
            carData = EPOCommunications('receive');
            obj.conn.send(carData);
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('New connection!\n');
            fprintf('%s\n',message)
            obj.conn = conn;
            obj.isOpen = true;
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
            % If there are no open connections to the server
            if length(obj.Connections) == 0
                obj.isOpen = false;
            end
            fprintf('%s\n',message)
        end
    end
end

