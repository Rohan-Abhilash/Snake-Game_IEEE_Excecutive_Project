`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2024 21:51:10
// Design Name: 
// Module Name: Led_Display_Controller_Test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Led_Display_Controller_Test(
    output hsync,vsync,
    output [3:0] vga_r,vga_g,vga_b,//output [15:0]Led_out,
    output clock_1s_led,
    input [3:0]buttons,input clock_100Mhz,reset
    );

wire [99:0]pos_x,pos_y;
//reg [15:0]Led_out_temp;
wire clock_1hz,clock_50Mhz,clock_25Mhz;
reg [3:0] color_r,color_g,color_b;
wire [9:0]pos_x_rand,pos_y_rand;
reg [9:0]curr_apple_x , curr_apple_y;
parameter [19:0]rand_seed = 212701;
reg apple_eaten;
reg [9:0]length = 0;
wire [9:0]head_x,head_y;
assign head_x = pos_x[9:0];
assign head_y = pos_y[9:0];
assign clock_1s_led = clock_1hz;

//assign Led_out = Led_out_temp;

Snake_Position_Controller control1(.pos_x(pos_x), .pos_y(pos_y),.buttons(buttons),.clock(clock_1hz), .reset(reset),.length(length));
Clock_Divider_1s clock1s(clock_1hz,clock_100Mhz,reset);
Clock_Divider_2 clock_by_two(clock_50Mhz,clock_100Mhz,reset);
Clock_Divider_25Mhz clock_3(clock_25Mhz,clock_100Mhz,reset);

Random_Generator random1(pos_x_rand,pos_y_rand,rand_seed,clock_1hz,reset);


vga_controller snake_display(
    .clk_25Mhz(clock_25Mhz),           // Main clock input
    .rst(reset),                // Reset signal
    .x_input(pos_x),      // X-coordinate (0-639 for 640x480 resolution)
    .y_input(pos_y),      // Y-coordinate (0-479 for 640x480 resolution)
    .length(length),
    .x_apple(curr_apple_x),
    .y_apple(curr_apple_y),
    .color_r(color_r),      // Red color (8 bits)
    .color_g(color_g),      // Green color (8 bits)
    .color_b(color_b),      // Blue color (8 bits)
    .hsync(hsync),         // Horizontal sync output
    .vsync(vsync),         // Vertical sync output
    .vga_r(vga_r),   // VGA red signal
    .vga_g(vga_g),   // VGA green signal
    .vga_b(vga_b)    // VGA blue signal
);

always @(posedge clock_100Mhz)begin
    color_r <= 4'b0;
    color_g <= 4'b1111;
    color_b <= 4'b0;
end

always @(posedge clock_1hz or posedge reset) begin
    if (reset) begin
        apple_eaten <= 0;
        curr_apple_x <= 400;
        curr_apple_y <= 200;
        length <= 0;
    end
    else begin
        if (head_x <= curr_apple_x + 4 && head_x >= curr_apple_x - 4 &&
            head_y <= curr_apple_y + 4 && head_y >= curr_apple_y - 4) begin
            apple_eaten <= 1;
            length <= length + 1;
        end
        else begin
            apple_eaten <= 0;
        end

        if (apple_eaten) begin
            curr_apple_x <= pos_x_rand;
            curr_apple_y <= pos_y_rand;
        end
    end
end

endmodule