module Snake_Position_Controller(output [10:0] pos_x, pos_y, input [3:0] buttons, input clock, reset);
//buttons [3] = up ; buttons[2] = right; buttons[1] = down; buttons[0] = left; 
reg signed [10:0] pos_x_temp, pos_y_temp;
assign pos_x = pos_x_temp;
assign pos_y = pos_y_temp;
reg signed [10:0] vel_x, vel_y;
reg signed [10:0] last_vel_x , last_vel_y;

parameter [10:0] monitor_width_pixels = 640;
parameter [10:0] monitor_height_pixels = 480;

always @(*) begin
    vel_x = last_vel_x;
    vel_y = last_vel_y;
    if (buttons[0] == 1) begin // left
        vel_x = -1;
        vel_y = 0;
    end 
    else if (buttons[1] == 1) begin // down
        vel_x = 0;
        vel_y = 1; // inverted Y axis
    end 
    else if (buttons[2] == 1) begin // right
        vel_x = 1;
        vel_y = 0;
    end 
    else if (buttons[3] == 1) begin // up
        vel_x = 0;
        vel_y = -1; // inverted Y axis
    end 
end

always @(posedge clock or posedge reset) begin
    if (reset == 1) begin
        pos_x_temp = 320;
        pos_y_temp = 240;
        last_vel_x = 0;
        last_vel_y = 0;
    end else begin
        pos_x_temp = pos_x_temp + vel_x;
        pos_y_temp = pos_y_temp + vel_y;
        
        if(buttons[3] == 1 || buttons[2] == 1 || buttons[1] == 1 || buttons[0] == 1)begin
            last_vel_x = vel_x;
            last_vel_y = vel_y;
        end

        if (pos_x_temp < 0) begin
            pos_x_temp = monitor_width_pixels - 1;  
        end
        else if (pos_x_temp >= monitor_width_pixels) begin
            pos_x_temp = 0;  
        end
        else if (pos_y_temp < 0) begin
            pos_y_temp = monitor_height_pixels - 1;  
        end
        else if (pos_y_temp >= monitor_height_pixels) begin
            pos_y_temp = 0;  
        end
    end
    $monitor("x_temp : %d  y_temp:%d", pos_x_temp, pos_y_temp);
end

endmodule
