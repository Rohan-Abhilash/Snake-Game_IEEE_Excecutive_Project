module vga_controller(
    input clk_25Mhz,                // Main clock input
    input rst,                // Reset signal
    input [99:0] x_input,      // X-coordinate (0-639 for 640x480 resolution)
    input [99:0] y_input,      // Y-coordinate (0-479 for 640x480 resolution)
    input [9:0] length,
    input [9:0] x_apple,
    input [9:0] y_apple,
    input [3:0] color_r,      // Red color (8 bits)
    input [3:0] color_g,      // Green color (8 bits)
    input [3:0] color_b,      // Blue color (8 bits)
    output reg hsync,         // Horizontal sync output
    output reg vsync,         // Vertical sync output
    output reg [3:0] vga_r,   // VGA red signal
    output reg [3:0] vga_g,   // VGA green signal
    output reg [3:0] vga_b    // VGA blue signal
);

    // VGA 640x480 @ 60Hz timing constants
    parameter H_VISIBLE_AREA = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = 800;

    parameter V_VISIBLE_AREA = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = 525;
    
    reg [99:0]temp_1s = 100'b1111111111;
    reg [99:0]value_x,value_y;
    integer i;

    reg [9:0] h_counter = 0;  // Horizontal pixel counter (0 to 799)
    reg [9:0] v_counter = 0;  // Vertical pixel counter (0 to 524)


    // VGA Horizontal and Vertical Counters
    always @(posedge clk_25Mhz or posedge rst) begin
        if (rst) begin
            h_counter <= 0;
            v_counter <= 0;
        end else begin
            // Horizontal counter (pixels per line)
            if (h_counter == H_TOTAL - 1) begin
                h_counter <= 0;
                // Vertical counter (lines per frame)
                if (v_counter == V_TOTAL - 1) begin
                    v_counter <= 0;
                end else begin
                    v_counter <= v_counter + 1;
                end
            end else begin
                h_counter <= h_counter + 1;
            end
        end
    end

    // Generate Horizontal and Vertical Sync signals
    always @(posedge clk_25Mhz or posedge rst) begin
        if (rst) begin
            hsync <= 1;
            vsync <= 1;
        end else begin
            // Horizontal sync
            if (h_counter >= H_VISIBLE_AREA + H_FRONT_PORCH && h_counter < H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE)
                hsync <= 0;
            else
                hsync <= 1;

            // Vertical sync
            if (v_counter >= V_VISIBLE_AREA + V_FRONT_PORCH && v_counter < V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE)
                vsync <= 0;
            else
                vsync <= 1;
        end
    end

    // Generate RGB values based on x and y input coordinates
    always @(posedge clk_25Mhz or posedge rst) begin
        if (rst) begin
            vga_r <= 0;
            vga_g <= 0;
            vga_b <= 0;
        end else begin
            if (h_counter < H_VISIBLE_AREA && v_counter < V_VISIBLE_AREA) begin
                value_x = x_input[99:0]; 
                value_y = y_input[99:0];
                if ( (h_counter <= value_x[9:0]+2 && h_counter >= value_x[9:0]-2 && v_counter <= value_y[9:0]+2 && v_counter >= value_y[9:0]-2) ||
                (h_counter <= value_x[19:10]+2 && h_counter >= value_x[19:10]-2 && v_counter <= value_y[19:10]+2 && v_counter >= value_y[19:10]-2)||
                (h_counter <= value_x[29:20]+2 && h_counter >= value_x[29:20]-2 && v_counter <= value_y[29:20]+2 && v_counter >= value_y[29:20]-2)||
                (h_counter <= value_x[39:30]+2 && h_counter >= value_x[39:30]-2 && v_counter <= value_y[39:30]+2 && v_counter >= value_y[39:30]-2)||
                (h_counter <= value_x[49:40]+2 && h_counter >= value_x[49:40]-2 && v_counter <= value_y[49:40]+2 && v_counter >= value_y[49:40]-2)||
                (h_counter <= value_x[59:50]+2 && h_counter >= value_x[59:50]-2 && v_counter <= value_y[59:50]+2 && v_counter >= value_y[59:50]-2)||
                (h_counter <= value_x[69:60]+2 && h_counter >= value_x[69:60]-2 && v_counter <= value_y[69:60]+2 && v_counter >= value_y[69:60]-2)||
                (h_counter <= value_x[79:70]+2 && h_counter >= value_x[79:70]-2 && v_counter <= value_y[79:70]+2 && v_counter >= value_y[79:70]-2)||
                (h_counter <= value_x[89:80]+2 && h_counter >= value_x[89:80]-2 && v_counter <= value_y[89:80]+2 && v_counter >= value_y[89:80]-2)||
                (h_counter <= value_x[99:90]+2 && h_counter >= value_x[99:90]-2 && v_counter <= value_y[99:90]+2 && v_counter >= value_y[99:90]-2)) begin
                    // Set color at the specified pixel
                    vga_r = 4'b0000;
                    vga_g = 4'b1111;
                    vga_b = 4'b0000;
                end
                else if (h_counter <= x_apple+2 && h_counter >= x_apple-2 && v_counter <= y_apple+2 && v_counter >= y_apple-2) begin
                    // Set color at the specified pixel
                    vga_r = 4'b1111;
                    vga_g = 4'b0;
                    vga_b = 4'b0;
                end                 
                else begin
                    // Set background color (black)
                    vga_r = 0;
                    vga_g = 0;
                    vga_b = 0;
                end
            end else begin
                // Blanking (set all colors to 0 during blanking periods)
                vga_r = 0;
                vga_g = 0;
                vga_b = 0;
            end
        end
    end

endmodule