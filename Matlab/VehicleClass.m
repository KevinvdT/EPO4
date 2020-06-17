classdef (Abstract) VehicleClass < handle
  
    methods(Abstract)
        update_values(self, x, y, yaw, speed, timestamp, frame);
    end
    properties
        current_x     
        current_y      
        current_yaw     
        current_speed     
        desired_speed    
        current_frame      
        current_timestamp 
        start_control_loop 
        set_throttle       
        set_brake         
        set_steer         
        waypoints         
        conv_rad_to_steer
        pi                               
    end
end