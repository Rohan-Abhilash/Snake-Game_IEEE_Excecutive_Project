`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2024 14:12:05
// Design Name: 
// Module Name: Random_Generator
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


module Random_Generator(output reg [9:0]pos_x_rand,pos_y_rand,input [19:0]rand_seed,input clock_1hz,reset);

reg [19:0]rand_temp ;

always @(negedge clock_1hz)begin
    if(reset == 1)begin
        rand_temp = 212701;
    end
    else begin
        rand_temp = rand_temp * 212701;
    end 
    
    pos_x_rand = rand_temp[19:10] % 10'd500;
    pos_y_rand = rand_temp[9:0] % 10'd450;
end

endmodule
