`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2024 17:30:01
// Design Name: 
// Module Name: Clock_Divider_2
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


module Clock_Divider_2(output clock_50Mhz,input clock_100Mhz,reset);

reg clock_temp;
assign clock_50Mhz = clock_temp;

always @(posedge clock_100Mhz)begin
    if(reset == 1)begin
        clock_temp <= 0;
    end
    else begin
        clock_temp <= ~clock_temp;
    end
end

endmodule

module Clock_Divider_25Mhz(output clock_25Mhz,input clock_100Mhz,reset);

reg clock_temp;
assign clock_25Mhz = clock_temp;
reg [2:0] counter;

always @(posedge clock_100Mhz)begin
    if(reset == 1)begin
        clock_temp <= 0;
        counter <= 0;
    end
    else begin
        if(counter >= 2)begin
            counter <= 0;
            clock_temp <= ~clock_temp;
        end
        else 
            counter = counter + 1;
    end
end

endmodule

module Clock_Divider_1s(output clock_1hz,input clock_100Mhz,input reset);

reg [31:0] counter;
reg clock_temp;
assign clock_1hz = clock_temp;

always @(posedge clock_100Mhz)begin
    if(reset == 1)begin
        counter <= 0;
        clock_temp <= 0;
    end
    else begin
        if(counter == 1000000)begin
            counter <= 0;
            clock_temp <= ~clock_temp;
        end
        else
            counter = counter + 1;
    end
end

endmodule



