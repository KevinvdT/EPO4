function output = EPOCommunication(messageType, message)
    car = evalin('base', 'car;');

    switch messageType
        case 'transmit'
            push(car, message);
        case 'receive'
            output = pull(car);
    end

end
