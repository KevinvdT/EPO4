classdef CarTest < matlab.unittest.TestCase

    properties
        car
    end

    % Runs before each (or all?) tests
    methods (TestMethodSetup)

        function createCar(testCase)

            % Make car object in base workspace
            command = 'car = Car;';
            evalin('base', command);

            % Set this car as property here
            testCase.car = evalin('base', 'car;');
        end

    end

    methods (Test)

        function testInitialPosition(testCase)
            car = testCase.car;
            position = car.position;
            velocity = car.velocity;
            testCase.verifyEqual(position, 0);
        end

        function testInitialVelocity(testCase)
            car = testCase.car;
            position = car.position;
            velocity = car.velocity;
            testCase.verifyEqual(velocity, 0);
        end

        function testSettingGettingPosition(testCase)
            testCase.car.position = 10;
            actualPosition = testCase.car.position;
            expectedPosition = 10;
            testCase.verifyEqual(actualPosition, expectedPosition);
        end

        function testSettingGettingVelocity(testCase)
            testCase.car.velocity = 10;
            actualVelocity = testCase.car.velocity;
            expectedVelocity = 10;
            testCase.verifyEqual(actualVelocity, expectedVelocity);
        end

        function testVelocityChangesPosition(testCase)
            velocity = 1;
            testCase.car.velocity = velocity;
            delay = 2; % seconds
            pause(delay);
            actualPosition = testCase.car.position;
            expectedPosition = delay * velocity;
            testCase.verifyEqual(actualPosition, expectedPosition, 'AbsTol', 0.05);
        end

        function testHasMaxVelocity(testCase)
            maxVelocity = testCase.car.velocity;
            testCase.verifyInstanceOf(maxVelocity, 'double');
        end

        function testPushVelocity(testCase)
            maxVelocity = testCase.car.maxVelocity;

            % Test with max velocity forwards
            message = 'M200';
            push(testCase.car, message);
            expectedVelocity = maxVelocity;
            actualVelocity = testCase.car.velocity;
            testCase.verifyEqual(actualVelocity, expectedVelocity);

            % Test with max velocity backwards
            message = 'M100';
            testCase.car = push(testCase.car, message);
            expectedVelocity = -maxVelocity;
            actualVelocity = testCase.car.velocity;
            testCase.verifyEqual(actualVelocity, expectedVelocity);

            % Test with zero velocity
            message = 'M150';
            testCase.car = push(testCase.car, message);
            expectedVelocity = 0;
            actualVelocity = testCase.car.velocity;
            testCase.verifyEqual(actualVelocity, expectedVelocity);
        end

        function testTransmitEpocommunications(testCase)
            command = 'car.maxVelocity;';
            maxVelocity = evalin('base', command);

            % Car should initialize with 0 velocity
            command = 'car.velocity;';
            velocity = evalin('base', command);
            testCase.verifyEqual(velocity, 0);

            % Setting the speed to +maxSpeed via EPOCommunications function
            EPOCommunications('transmit', 'M200');
            command = 'car.velocity;';
            actualVelocity = evalin('base', command);
            expectedVelocity = maxVelocity;
            testCase.verifyEqual(actualVelocity, expectedVelocity);
        end

    end

end
