
classdef GuiServer < WebSocketServer
    %GuiServer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isOpen
    end
    
    methods
        function obj = GuiServer(varargin)
            
            %Constructor
            obj@WebSocketServer(varargin{:});
            obj.isOpen = false;
            
        end

        function sendState(obj)
            % Receive car data
            carData = EPOCommunications('receive');
            carDataJson = jsonencode(carData);
            % If there is a connection (or more)
            if ~isempty(obj.Connections)
                % Send data to the connection
                for index = length(obj.Connections)
                    clientCode = obj.Connections(index).HashCode;
                    obj.sendTo(clientCode, carDataJson);
                end
            end
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('New connection!\n');
            fprintf('%s\n',message);
            obj.isOpen = true;
        end
        
        function onTextMessage(obj,conn,message)
            disp(message);
            % This function sends an echo back to the client
            data = jsondecode(message);
            controller = evalin('base', 'controller');
            switch data.type
                case 'voiceCommand'
                    
                    handleVoiceCommand(controller);
            end
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

