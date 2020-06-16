classdef VehicleControl < VehicleClass
     properties
            v_previous         = 0.0;
            t_previous         = 0.0;
            error_previous     = 0.0;
            integral_error_previous = 0.0;
            throttle_previous  = 0.0;
        end
     methods
        function self = VehicleControl()
            % Constructor for the vehicle
            self.current_x          = 0;
            self.current_y          = 0;
            self.current_yaw        = 0;
            self.current_speed      = 0;
            self.desired_speed      = 0;
            self.current_frame      = 0;
            self.current_timestamp  = 0;
            self.start_control_loop = false;
            self.set_throttle       = 0;
            self.set_brake          = 0;
            self.set_steer          = 0;
            % waypoints               = [];
            self.waypoints          = [];
            self.conv_rad_to_steer  = 180.0 / 70.0 / pi;
            % self.pi                 = pi;
                                
        end    
       
        function update_values(self, x, y, yaw, speed, timestamp, frame)
            self.current_x         = x;
            self.current_y         = y;
            self.current_yaw       = yaw;
            self.current_speed     = speed;
            self.current_timestamp = timestamp;
            self.current_frame     = frame;
            if self.current_frame
                self.start_control_loop = True;
            end
        end
        
        function update_desired_speed(self)
        min_idx       = 0;
        min_dist      = inf;
        % REVIEW (Kevin): desired_speed variable is unused?
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
                desired_speed = self.waypoints(-1,2);
            end
            self.desired_speed = desired_speed;
        end
        
        function update_waypoints(self, new_waypoints)
          self.waypoints = new_waypoints;
        end
        function commands = get_commands(self)
            commands =[self.set_throttle, self.set_steer, self.set_brake];
        end
        function set_throttle(self, input_throttle)
            throttle           = max(min(input_throttle, 1.0), 0.0);
            self.set_throttle = throttle;
        end
        function set_steer(self, input_steer_in_rad)
            input_steer = self.conv_rad_to_steer * input_steer_in_rad;
            steer = max(min(input_steer, 1.0), -1.0);
            self.set_steer = steer;
        end

        function set_brake(self, input_brake)
            brake= max(min(input_brake, 1.0), 0.0);
            self.set_brake = brake;
        end
        function update_controls(self)
            x               = self.current_x;
            y               = self.current_y;
            yaw             = self.current_yaw;
            v               = self.current_speed;
            self.update_desired_speed();
            v_desired       = self.desired_speed;
            t               = self.current_timestamp;
            waypoints       = self.waypoints;
            throttle_output = 0;
            steer_output    = 0;
            brake_output    = 0;
            
            self.v_previous = 0.0;
            self.t_previous = 0.0;
            self.error_previous = 0.0;
            self.integral_error_previous = 0.0;
            self.throttle_previous = 0.0;
            
             for i = 1:(length(self.waypoints))
                kp = 1.0;
                ki = 0.2;
                kd = 0.01;

                throttle_output = 0;
                brake_output    = 0;
                st = t - self.t_previous;
                e_v = v_desired - v;
                inte_v = self.integral_error_previous + e_v * st;
                derivate = (e_v - self.error_previous) / st;
                acc = kp * e_v + ki * inte_v + kd * derivate;

                if acc > 0
                    throttle_output = (tanh(acc) + 1)/2;
                    if throttle_output - self.throttle_previous > 0.1;
                        throttle_output = self.throttle_previous + 0.1;
                    end
                else
                throttle_output = 0;
                end
                
                % Change the steer output with the lateral controller. 
                steer_output = 0;

                % Use controller for lateral control
                k_e = 0.3;
                slope = (waypoints(i-1,2)-waypoints(i,2))/ (waypoints(i-1,1)-waypoints(i,1));
                a = -slope;
                b = 1.0;
                c = (slope*waypoints(i,1)) - waypoints(i-1,1);

                % heading error
                yaw_path = atan((waypoints(i-1,2)-waypoints(i,2))/ (waypoints(i-1,1)-waypoints(i,1)));
                yaw_diff_heading = yaw_path - yaw ;
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
                yaw_cross_track = atan(y-waypoints(i,2), x-waypoints(i,1));
                yaw_path2ct = yaw_path - yaw_cross_track
                if yaw_path2ct > pi
                    yaw_path2ct =yaw_path2ct- 2 * pi;
                end
                if yaw_path2ct < - pi
                    yaw_path2ct =yaw_path2ct+ 2 * pi;
                end
                if yaw_path2ct > 0
                    crosstrack_error = abs(crosstrack_error);
                else
                    crosstrack_error = - abs(crosstrack_error)
                end
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

                self.set_throttle(throttle_output)  % in percent (0 to 1)
                self.set_steer(steer_output)        % in rad (-1.22 to 1.22)
                self.set_brake(brake_output)        % in percent (0 to 1)

                self.v_previous = v  % Store forward speed to be used in next step
                self.throttle_previous = throttle_output
                self.t_previous = t
                self.error_previous = e_v
                self.integral_error_previous = inte_v               
            
            end
        end
    end
end
