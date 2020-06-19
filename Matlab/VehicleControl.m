classdef VehicleControl < VehicleClass
 properties
     %initializing PID controller to prevent garbage values
        v_previous         = 0.0;
        t_previous         = 0.0;
        error_previous     = 0.0;
        integral_error_previous = 0.0;
        throttle_previous  = 0.0;
        
        kittHasStarted
        kittHasInitialized
        
        refpath
        min_idx
        min_dist
        
        start_x
        start_y
        final_x
        final_y
        start_yaw_deg

        start_t

        % current_x
        % current_y
        % current_yaw
        % current_speed
    end
 methods
    function self = VehicleControl()
        % Constructor for the vehicle
        % to initialize the vehicle, you have to pass and update this using
        % the KITT parameters
        self.current_x          = 0;    %this is x coordinate of KITT
        self.current_y          = 0;    %this is y coordinate of KITT
        self.current_yaw        = 0;    %this is same as KITT.angle
        self.current_speed      = 0;    %this is current speed of KITT
        self.desired_speed      = 0;    %this is desired tracking speed of KITT
        self.current_timestamp  = 0;    % current time stamp to calculate derivative terms
        self.start_control_loop = false;
        self.set_throttle       = 0;    % Force variable for KITT
        self.set_brake          = 0;    % Braking Force variable for KITT
        waypoints               = [0 0];% starting waypoint is given, but needs to be updated with each iteration
        self.waypoints          = waypoints;%initialize waypoints
        self.conv_rad_to_steer  = 180.0 / 70.0 / pi;
        self.pi                 = pi;
        self.kittHasStarted     = false;
        self.kittHasInitialized = false;

    end

    function self = initializeKitt(self)
        if self.kittHasInitialized
            return;
        end
        global kitt
        self.kittHasInitialized = true;
        % initializations
        setPositionCommand = ['X[' int2str(self.start_x) ';' int2str(self.start_y) ']'];
        EPOCommunications('init',setPositionCommand);	% initial position of car

        directionVector = [cosd(self.start_yaw_deg), sind(self.start_yaw_deg)];
        setOrientationCommand = ['D[' num2str(directionVector(1)) ';' num2str(directionVector(2)) ']'];
        EPOCommunications('init', setOrientationCommand);	% initial direction of car
        
        P = [
        0   600     0   600;
        0     0   600   600;
        30   30    30    30];
        pp = mat2str(P);
        EPOCommunications('init',['P' pp]);% initialize positions of mics
        EPOCommunications('init','J20000');	% set sample rate of mics
        EPOCommunications('init','N2000');	% set number of samples to return


        % define arena boundary
        B1 = [
        -50 650 650 -50;
        -50 -50 650 650];	% outer arena boundary (outside bounding box)
        NAN = [NaN; NaN];	% spacer between objects
        B2 = [
        -21 621 621 -21;
        -21 -21 621 621];	% inner arena boundary (hole since it overlaps B1)
        bb = mat2str([B1 NAN B2]);
        EPOCommunications('init',['O' bb]);	% initialize arena boundary

        W = [
        100   400;
        100   400];
        ww = mat2str(W);
        EPOCommunications('init',['W' ww]);	% initialize waypoints

        % create kitt!
        
        kitt = EPOCommunications('open','P');	% create kitt (P = public, with access
                                % to position, orientation, velocity)
        % self.kitt = kitt;
        x = 5;

        % ASTAR ALGORITHM
        self.start_t = tic;				% start timer
        % vehicle = VehicleControl;
        image = imread('map.png');
        grayimage = rgb2gray(image);
        bwimage = im2bw(image,0.5);
        bwimage = ~bwimage;

        grid = binaryOccupancyMap(bwimage);

        % show(grid)
        validator = validatorOccupancyMap;
        validator.Map = grid;
        planner = plannerHybridAStar(validator,'MinTurningRadius',60,'MotionPrimitiveLength',10);
        startAngleRadians = self.start_yaw_deg * (2*pi) / 360;
        startPose = [self.start_x self.start_y startAngleRadians]; % [meters, meters, radians]
        
        goalPose = [self.final_x self.final_y pi/2];
        self.refpath = plan(planner,startPose,goalPose);
        % show(planner)

        self.min_idx       = 1;
    end

    function startKitt(self)
        self.kittHasStarted = true;
        % kitt.force = 155;
    end

    function update_all(self)
            if self.kittHasStarted
                % disp('vehicleControl update()')
                self.update_path();
            end
        end

    function update_path(self)
        global kitt

        now = self.start_t;
        en_x = self.final_x;
        en_y = self.final_y;
        % query car status (kitt automatic updates as time progresses)
        x = kitt.position;
        d = kitt.orientation;
        a = kitt.angle;
        v = kitt.velocity;
        t = toc(now);
        % if n>1
        % %     kitt.angle=150+(refpath.States(n,3)-refpath.States(n-1,3))*180/pi;
        % end
        
            
        min_dist      = inf;
        refpath = self.refpath;
        min_idx = self.min_idx;

        for i = min_idx:refpath.NumStates-2
            dist = sqrt((refpath.States(i,1) - x(1))^2+(refpath.States(i,2) - x(2))^2);
            dist2 = sqrt((refpath.States(i+1,1) - x(1))^2+(refpath.States(i+1,2) - x(2))^2);
            dist3 = sqrt((refpath.States(i+2,1) - x(1))^2+(refpath.States(i+2,2) - x(2))^2);
            if dist < min_dist
                min_dist = dist;
                min_idx = i;
            end
            if dist>0
                kitt.force = 151;
                
            elseif x(2)<200
                kitt.force =151;
            else
                kitt.force =150;
            end
            if x(2)>en_y
                kitt.force =150;
            end
            if x(1)>en_x
                kitt.force =150;
            end
            if dist2>dist
                break
            
            elseif dist3 > dist2
                break
            end
        end
        kitt.angle = (refpath.States(min_idx+2,3)-refpath.States(min_idx,3))*20*180/pi+150;
    
        kitt.angle;
        self.min_idx = min_idx;
        self.min_dist = min_dist;

        self.current_x = kitt.position(1);
        self.current_y = kitt.position(2);
        kittOrientation = kitt.orientation;
        self.current_yaw = atan2(kittOrientation(2), kittOrientation(1));
        % a = kitt.angle;
        self.current_speed = kitt.velocity;
    end
   %%
    function self=i_values(self, x, y, yaw, speed, timestamp)  %Call this function 
%                                            in each iteration to update the value from KITT
        self.current_x         = x; 
        self.current_y         = y;
        self.current_yaw       = yaw;
        self.current_speed     = speed;
        self.current_timestamp = timestamp;
        if self.current_frame               %to verify that first value is updated and then process begins to avoid any garbage values
            self.start_control_loop = true;
        end
    end
    %%
    function self=update_desired_speed(self)    %update the tracking speed. Generalised for now. 
    min_idx       = 0;
    min_dist      = inf;
    desired_speed = 20;
    for i = 1:(length(self.waypoints))
        dist = [self.waypoints(i,1) - self.current_x,
                self.waypoints(i,2) - self.current_y];
        if dist < min_dist
            min_dist = dist;
            min_idx = i;
        end
    end
        if min_idx < length(self.waypoints)-1
        desired_speed = self.waypoints(min_idx,2);

        else
            desired_speed = self.waypoints(-1,2)
        end
        self.desired_speed = desired_speed
    end
    %%
    function self=update_waypoints(self, new_waypoints) %update the waypoints in each iteration by calling this function
      self.waypoints = new_waypoints
    end
    %%
    function commands = get_commands(self) %take the vehicle parameters calculated and store in commands array, the throttle sets the forcem and steer sets the angle for the next position(OUTPUTS)
        commands =[self.set_throttle, self.set_steer, self.set_brake];
    end
    %%
    function self=set_throttle(self, input_throttle)    %this is called if you manually want to set the force variable
        throttle = max(min(input_throttle, 1.0), 0.0);% clipping the throttle in the range, set this to max and min force bounds
        self.set_throttle = throttle;
    end
       %%
    function self=set_steer(self, input_steer_in_rad)%this is called if you manually want to set the angle variable
        input_steer = self.conv_rad_to_steer * input_steer_in_rad;
        steer = max(min(input_steer, 1.0), -1.0);% clipping the angle in the range, set this to max and min angle bounds
        self.set_steer = steer;
    end
%%
    function self=set_brake(self, input_brake)% if you are using braking force to stop, use this function to set the value
        brake= max(min(input_brake, 1.0), 0.0);
        self.set_brake = brake;
    end
    %%
    function self=update_controls(self,i)   % this is the main function that estimates the parameters for the force and steering angle and updates the values internally
        x               = self.current_x;
        y               = self.current_y;
        yaw             = self.current_yaw;
        v               = self.current_speed;
        self.update_desired_speed();
        v_desired       = self.desired_speed;
        t               = self.current_timestamp;
        waypoints       = self.waypoints;
        throttle_output = self.set_throttle;
        steer_output    = self.set_steer;
        brake_output    = self.set_brake;

%         self.v_previous = 0.0;
%         self.t_previous = 0.0;
%         self.error_previous = 0.0;
%         self.integral_error_previous = 0.0;
%         self.throttle_previous = 0.0;
        %% longitudional controller 
        if i>1  % ensure the first readings are processed and stored to have a past reading
        kp = 1.0;
        ki = 0.2;
        kd = 0.01;

        st = t - self.t_previous;   %differential time frame
        e_v = v_desired - v;        %error in velocity
        inte_v = self.integral_error_previous + e_v * st;%finding the integral gain for PID
        derivate = (e_v - self.error_previous) / st;     %finding the derivative gain for PID
        acc = kp * e_v + ki * inte_v + kd * derivate;    %accumulated error

        if acc > 0
            throttle_output = (tanh(acc) + 1)/2;
            if throttle_output - self.throttle_previous > 0.1;
                throttle_output = self.throttle_previous + 0.1;
            end
        else
        throttle_output = 0;
        end

      
        %% lateral controller
        k_e = 0.3;
        % finding the slope from using the formula y2-y1/x2-x1
        slope = (waypoints(i-1,2)-waypoints(i,2))/ (waypoints(i-1,1)-waypoints(i,1));
        a = -slope;
        b = 1.0;
        c = (slope*waypoints(i,1)) - waypoints(i-1,1);

        % heading error
        yaw_path = atan((waypoints(i-1,2)-waypoints(i,2))/ (waypoints(i-1,1)-waypoints(i,1)));
        %finding the required angle to track the next waypoint
        yaw_diff_heading = yaw_path - yaw ;
        %the error in the heading error evaluated
        %giving the shifts of pi or -pi to have the angle in the range
        if yaw_diff_heading > pi
            yaw_diff_heading =yaw_diff_heading- 2 * pi;
        end
        if yaw_diff_heading < - pi
            yaw_diff_heading =yaw_diff_heading+ 2 *pi;
        end
        % crosstrack error
        current_xy = [x y];
%                 crosstrack_error = min(sum((current_xy - [waypoints)[:, :2])^2, axis=1))
        crosstrack_error= min(sum((current_xy - waypoints(i,:))));
        yaw_cross_track = atan(y-waypoints(i,2)/ x-waypoints(i,1));
        yaw_path2ct = yaw_path - yaw_cross_track
        if yaw_path2ct > pi
            yaw_path2ct =yaw_path2ct- 2 * pi;
        end
        if yaw_path2ct < - pi
            yaw_path2ct =yaw_path2ct+ 2 * pi;
        end
        %determining the direction of angle movement
        if yaw_path2ct > 0
            crosstrack_error = abs(crosstrack_error);
        else
            crosstrack_error = - abs(crosstrack_error)
        end
        %equation derived from lateral controller
        yaw_diff_crosstrack = atan(k_e * crosstrack_error / (v))

        % final expected steering
        steer_expect = yaw_diff_crosstrack + yaw_diff_heading
        if steer_expect > pi
            steer_expect =steer_expect- 2 * pi;
        end
        if steer_expect < - pi
           steer_expect =steer_expect + 2 * pi;
        end
        steer_expect = min(1.22, steer_expect);
        steer_expect = max(-1.22, steer_expect);

        %update
        steer_output = steer_expect;

        self.set_throttle=throttle_output  % in percent (0 to 1)
        self.set_steer=steer_output        % in rad (-1.22 to 1.22)
        self.set_brake=brake_output       % in percent (0 to 1)
        
        self.v_previous = v  % Store forward speed to be used in next step
        self.throttle_previous = throttle_output
        self.t_previous = t
        self.error_previous = e_v
        self.integral_error_previous = inte_v               

        end
    end
 end
end
