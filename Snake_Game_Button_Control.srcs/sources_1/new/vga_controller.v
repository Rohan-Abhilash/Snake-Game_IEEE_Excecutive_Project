module vga_controller(
    input clk_25Mhz,                // Main clock input
    input rst,                // Reset signal
    input [999:0] x_input,      // X-coordinate (0-639 for 640x480 resolution)
    input [999:0] y_input,      // Y-coordinate (0-479 for 640x480 resolution)
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
    
/*    // VGA 1366x768 @ 60Hz timing constants
        parameter H_VISIBLE_AREA = 1366;
        parameter H_FRONT_PORCH  = 70;
        parameter H_SYNC_PULSE   = 143;
        parameter H_BACK_PORCH  = 217;
        parameter H_TOTAL   = 1796;
        
        parameter V_VISIBLE_AREA = 768;
        parameter V_FRONT_PORCH  = 3;
        parameter V_SYNC_PULSE   = 10;
        parameter V_BACK_PORCH  = 17;
        parameter V_TOTAL  = 798;*/

    
    reg [99:0]temp_1s = 100'b1111111111;
    reg [999:0]value_x,value_y;
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
                value_x = x_input[999:0]; 
                value_y = y_input[999:0];
                if ( (h_counter <= value_x[9:0]+2 && h_counter >= value_x[9:0]-2 && v_counter <= value_y[9:0]+2 && v_counter >= value_y[9:0]-2) ||
                (h_counter <= value_x[19:10]+2 && h_counter >= value_x[19:10]-2 && v_counter <= value_y[19:10]+2 && v_counter >= value_y[19:10]-2)||
                (h_counter <= value_x[29:20]+2 && h_counter >= value_x[29:20]-2 && v_counter <= value_y[29:20]+2 && v_counter >= value_y[29:20]-2)||
                (h_counter <= value_x[39:30]+2 && h_counter >= value_x[39:30]-2 && v_counter <= value_y[39:30]+2 && v_counter >= value_y[39:30]-2)||
                (h_counter <= value_x[49:40]+2 && h_counter >= value_x[49:40]-2 && v_counter <= value_y[49:40]+2 && v_counter >= value_y[49:40]-2)||
                (h_counter <= value_x[59:50]+2 && h_counter >= value_x[59:50]-2 && v_counter <= value_y[59:50]+2 && v_counter >= value_y[59:50]-2)||
                (h_counter <= value_x[69:60]+2 && h_counter >= value_x[69:60]-2 && v_counter <= value_y[69:60]+2 && v_counter >= value_y[69:60]-2)||
                (h_counter <= value_x[79:70]+2 && h_counter >= value_x[79:70]-2 && v_counter <= value_y[79:70]+2 && v_counter >= value_y[79:70]-2)||
                (h_counter <= value_x[89:80]+2 && h_counter >= value_x[89:80]-2 && v_counter <= value_y[89:80]+2 && v_counter >= value_y[89:80]-2)||
                (h_counter <= value_x[99:90]+2 && h_counter >= value_x[99:90]-2 && v_counter <= value_y[99:90]+2 && v_counter >= value_y[99:90]-2)||
                (h_counter <= value_x[9:0] + 2 && h_counter >= value_x[9:0] - 2 && v_counter <= value_y[9:0] + 2 && v_counter >= value_y[9:0] - 2) ||
                (h_counter <= value_x[19:10] + 2 && h_counter >= value_x[19:10] - 2 && v_counter <= value_y[19:10] + 2 && v_counter >= value_y[19:10] - 2) ||
                (h_counter <= value_x[29:20] + 2 && h_counter >= value_x[29:20] - 2 && v_counter <= value_y[29:20] + 2 && v_counter >= value_y[29:20] - 2) ||
                (h_counter <= value_x[39:30] + 2 && h_counter >= value_x[39:30] - 2 && v_counter <= value_y[39:30] + 2 && v_counter >= value_y[39:30] - 2) ||
                (h_counter <= value_x[49:40] + 2 && h_counter >= value_x[49:40] - 2 && v_counter <= value_y[49:40] + 2 && v_counter >= value_y[49:40] - 2) ||
                (h_counter <= value_x[59:50] + 2 && h_counter >= value_x[59:50] - 2 && v_counter <= value_y[59:50] + 2 && v_counter >= value_y[59:50] - 2) ||
                (h_counter <= value_x[69:60] + 2 && h_counter >= value_x[69:60] - 2 && v_counter <= value_y[69:60] + 2 && v_counter >= value_y[69:60] - 2) ||
                (h_counter <= value_x[79:70] + 2 && h_counter >= value_x[79:70] - 2 && v_counter <= value_y[79:70] + 2 && v_counter >= value_y[79:70] - 2) ||
                (h_counter <= value_x[89:80] + 2 && h_counter >= value_x[89:80] - 2 && v_counter <= value_y[89:80] + 2 && v_counter >= value_y[89:80] - 2) ||
                (h_counter <= value_x[99:90] + 2 && h_counter >= value_x[99:90] - 2 && v_counter <= value_y[99:90] + 2 && v_counter >= value_y[99:90] - 2) ||
                (h_counter <= value_x[109:100] + 2 && h_counter >= value_x[109:100] - 2 && v_counter <= value_y[109:100] + 2 && v_counter >= value_y[109:100] - 2) ||
                (h_counter <= value_x[119:110] + 2 && h_counter >= value_x[119:110] - 2 && v_counter <= value_y[119:110] + 2 && v_counter >= value_y[119:110] - 2) ||
                (h_counter <= value_x[129:120] + 2 && h_counter >= value_x[129:120] - 2 && v_counter <= value_y[129:120] + 2 && v_counter >= value_y[129:120] - 2) ||
                (h_counter <= value_x[139:130] + 2 && h_counter >= value_x[139:130] - 2 && v_counter <= value_y[139:130] + 2 && v_counter >= value_y[139:130] - 2) ||
                (h_counter <= value_x[149:140] + 2 && h_counter >= value_x[149:140] - 2 && v_counter <= value_y[149:140] + 2 && v_counter >= value_y[149:140] - 2) ||
                (h_counter <= value_x[159:150] + 2 && h_counter >= value_x[159:150] - 2 && v_counter <= value_y[159:150] + 2 && v_counter >= value_y[159:150] - 2) ||
                (h_counter <= value_x[169:160] + 2 && h_counter >= value_x[169:160] - 2 && v_counter <= value_y[169:160] + 2 && v_counter >= value_y[169:160] - 2) ||
                (h_counter <= value_x[179:170] + 2 && h_counter >= value_x[179:170] - 2 && v_counter <= value_y[179:170] + 2 && v_counter >= value_y[179:170] - 2) ||
                (h_counter <= value_x[189:180] + 2 && h_counter >= value_x[189:180] - 2 && v_counter <= value_y[189:180] + 2 && v_counter >= value_y[189:180] - 2) ||
                (h_counter <= value_x[199:190] + 2 && h_counter >= value_x[199:190] - 2 && v_counter <= value_y[199:190] + 2 && v_counter >= value_y[199:190] - 2) ||
                (h_counter <= value_x[209:200] + 2 && h_counter >= value_x[209:200] - 2 && v_counter <= value_y[209:200] + 2 && v_counter >= value_y[209:200] - 2) ||
                (h_counter <= value_x[219:210] + 2 && h_counter >= value_x[219:210] - 2 && v_counter <= value_y[219:210] + 2 && v_counter >= value_y[219:210] - 2) ||
                (h_counter <= value_x[229:220] + 2 && h_counter >= value_x[229:220] - 2 && v_counter <= value_y[229:220] + 2 && v_counter >= value_y[229:220] - 2) ||
                (h_counter <= value_x[239:230] + 2 && h_counter >= value_x[239:230] - 2 && v_counter <= value_y[239:230] + 2 && v_counter >= value_y[239:230] - 2) ||
                (h_counter <= value_x[249:240] + 2 && h_counter >= value_x[249:240] - 2 && v_counter <= value_y[249:240] + 2 && v_counter >= value_y[249:240] - 2) ||
                (h_counter <= value_x[259:250] + 2 && h_counter >= value_x[259:250] - 2 && v_counter <= value_y[259:250] + 2 && v_counter >= value_y[259:250] - 2) ||
                (h_counter <= value_x[269:260] + 2 && h_counter >= value_x[269:260] - 2 && v_counter <= value_y[269:260] + 2 && v_counter >= value_y[269:260] - 2) ||
                (h_counter <= value_x[279:270] + 2 && h_counter >= value_x[279:270] - 2 && v_counter <= value_y[279:270] + 2 && v_counter >= value_y[279:270] - 2) ||
                (h_counter <= value_x[289:280] + 2 && h_counter >= value_x[289:280] - 2 && v_counter <= value_y[289:280] + 2 && v_counter >= value_y[289:280] - 2) ||
                (h_counter <= value_x[299:290] + 2 && h_counter >= value_x[299:290] - 2 && v_counter <= value_y[299:290] + 2 && v_counter >= value_y[299:290] - 2) ||
                (h_counter <= value_x[309:300] + 2 && h_counter >= value_x[309:300] - 2 && v_counter <= value_y[309:300] + 2 && v_counter >= value_y[309:300] - 2) ||
                (h_counter <= value_x[319:310] + 2 && h_counter >= value_x[319:310] - 2 && v_counter <= value_y[319:310] + 2 && v_counter >= value_y[319:310] - 2) ||
                (h_counter <= value_x[329:320] + 2 && h_counter >= value_x[329:320] - 2 && v_counter <= value_y[329:320] + 2 && v_counter >= value_y[329:320] - 2) ||
                (h_counter <= value_x[339:330] + 2 && h_counter >= value_x[339:330] - 2 && v_counter <= value_y[339:330] + 2 && v_counter >= value_y[339:330] - 2) ||
                (h_counter <= value_x[349:340] + 2 && h_counter >= value_x[349:340] - 2 && v_counter <= value_y[349:340] + 2 && v_counter >= value_y[349:340] - 2) ||
                (h_counter <= value_x[359:350] + 2 && h_counter >= value_x[359:350] - 2 && v_counter <= value_y[359:350] + 2 && v_counter >= value_y[359:350] - 2) ||
                (h_counter <= value_x[369:360] + 2 && h_counter >= value_x[369:360] - 2 && v_counter <= value_y[369:360] + 2 && v_counter >= value_y[369:360] - 2) ||
                (h_counter <= value_x[379:370] + 2 && h_counter >= value_x[379:370] - 2 && v_counter <= value_y[379:370] + 2 && v_counter >= value_y[379:370] - 2) ||
                (h_counter <= value_x[389:380] + 2 && h_counter >= value_x[389:380] - 2 && v_counter <= value_y[389:380] + 2 && v_counter >= value_y[389:380] - 2) ||
                (h_counter <= value_x[399:390] + 2 && h_counter >= value_x[399:390] - 2 && v_counter <= value_y[399:390] + 2 && v_counter >= value_y[399:390] - 2) ||
                (h_counter <= value_x[409:400] + 2 && h_counter >= value_x[409:400] - 2 && v_counter <= value_y[409:400] + 2 && v_counter >= value_y[409:400] - 2) ||
                (h_counter <= value_x[419:410] + 2 && h_counter >= value_x[419:410] - 2 && v_counter <= value_y[419:410] + 2 && v_counter >= value_y[419:410] - 2) ||
                (h_counter <= value_x[429:420] + 2 && h_counter >= value_x[429:420] - 2 && v_counter <= value_y[429:420] + 2 && v_counter >= value_y[429:420] - 2) ||
                (h_counter <= value_x[439:430] + 2 && h_counter >= value_x[439:430] - 2 && v_counter <= value_y[439:430] + 2 && v_counter >= value_y[439:430] - 2) ||
                (h_counter <= value_x[449:440] + 2 && h_counter >= value_x[449:440] - 2 && v_counter <= value_y[449:440] + 2 && v_counter >= value_y[449:440] - 2) ||
                (h_counter <= value_x[459:450] + 2 && h_counter >= value_x[459:450] - 2 && v_counter <= value_y[459:450] + 2 && v_counter >= value_y[459:450] - 2) ||
                (h_counter <= value_x[469:460] + 2 && h_counter >= value_x[469:460] - 2 && v_counter <= value_y[469:460] + 2 && v_counter >= value_y[469:460] - 2) ||
                (h_counter <= value_x[479:470] + 2 && h_counter >= value_x[479:470] - 2 && v_counter <= value_y[479:470] + 2 && v_counter >= value_y[479:470] - 2) ||
                (h_counter <= value_x[489:480] + 2 && h_counter >= value_x[489:480] - 2 && v_counter <= value_y[489:480] + 2 && v_counter >= value_y[489:480] - 2) ||
                (h_counter <= value_x[499:490] + 2 && h_counter >= value_x[499:490] - 2 && v_counter <= value_y[499:490] + 2 && v_counter >= value_y[499:490] - 2) ||
                (h_counter <= value_x[509:500] + 2 && h_counter >= value_x[509:500] - 2 && v_counter <= value_y[509:500] + 2 && v_counter >= value_y[509:500] - 2) ||
                (h_counter <= value_x[519:510] + 2 && h_counter >= value_x[519:510] - 2 && v_counter <= value_y[519:510] + 2 && v_counter >= value_y[519:510] - 2) ||
                (h_counter <= value_x[529:520] + 2 && h_counter >= value_x[529:520] - 2 && v_counter <= value_y[529:520] + 2 && v_counter >= value_y[529:520] - 2) ||
                (h_counter <= value_x[539:530] + 2 && h_counter >= value_x[539:530] - 2 && v_counter <= value_y[539:530] + 2 && v_counter >= value_y[539:530] - 2) ||
                (h_counter <= value_x[549:540] + 2 && h_counter >= value_x[549:540] - 2 && v_counter <= value_y[549:540] + 2 && v_counter >= value_y[549:540] - 2) ||
                (h_counter <= value_x[559:550] + 2 && h_counter >= value_x[559:550] - 2 && v_counter <= value_y[559:550] + 2 && v_counter >= value_y[559:550] - 2) ||
                (h_counter <= value_x[569:560] + 2 && h_counter >= value_x[569:560] - 2 && v_counter <= value_y[569:560] + 2 && v_counter >= value_y[569:560] - 2) ||
                (h_counter <= value_x[579:570] + 2 && h_counter >= value_x[579:570] - 2 && v_counter <= value_y[579:570] + 2 && v_counter >= value_y[579:570] - 2) ||
                (h_counter <= value_x[589:580] + 2 && h_counter >= value_x[589:580] - 2 && v_counter <= value_y[589:580] + 2 && v_counter >= value_y[589:580] - 2) ||
                (h_counter <= value_x[599:590] + 2 && h_counter >= value_x[599:590] - 2 && v_counter <= value_y[599:590] + 2 && v_counter >= value_y[599:590] - 2) ||
                (h_counter <= value_x[609:600] + 2 && h_counter >= value_x[609:600] - 2 && v_counter <= value_y[609:600] + 2 && v_counter >= value_y[609:600] - 2) ||
                (h_counter <= value_x[619:610] + 2 && h_counter >= value_x[619:610] - 2 && v_counter <= value_y[619:610] + 2 && v_counter >= value_y[619:610] - 2) ||
                (h_counter <= value_x[629:620] + 2 && h_counter >= value_x[629:620] - 2 && v_counter <= value_y[629:620] + 2 && v_counter >= value_y[629:620] - 2) ||
                (h_counter <= value_x[639:630] + 2 && h_counter >= value_x[639:630] - 2 && v_counter <= value_y[639:630] + 2 && v_counter >= value_y[639:630] - 2) ||
                (h_counter <= value_x[649:640] + 2 && h_counter >= value_x[649:640] - 2 && v_counter <= value_y[649:640] + 2 && v_counter >= value_y[649:640] - 2) ||
                (h_counter <= value_x[659:650] + 2 && h_counter >= value_x[659:650] - 2 && v_counter <= value_y[659:650] + 2 && v_counter >= value_y[659:650] - 2) ||
                (h_counter <= value_x[669:660] + 2 && h_counter >= value_x[669:660] - 2 && v_counter <= value_y[669:660] + 2 && v_counter >= value_y[669:660] - 2) ||
                (h_counter <= value_x[679:670] + 2 && h_counter >= value_x[679:670] - 2 && v_counter <= value_y[679:670] + 2 && v_counter >= value_y[679:670] - 2) ||
                (h_counter <= value_x[689:680] + 2 && h_counter >= value_x[689:680] - 2 && v_counter <= value_y[689:680] + 2 && v_counter >= value_y[689:680] - 2) ||
                (h_counter <= value_x[699:690] + 2 && h_counter >= value_x[699:690] - 2 && v_counter <= value_y[699:690] + 2 && v_counter >= value_y[699:690] - 2) ||
                (h_counter <= value_x[709:700] + 2 && h_counter >= value_x[709:700] - 2 && v_counter <= value_y[709:700] + 2 && v_counter >= value_y[709:700] - 2) ||
                (h_counter <= value_x[719:710] + 2 && h_counter >= value_x[719:710] - 2 && v_counter <= value_y[719:710] + 2 && v_counter >= value_y[719:710] - 2) ||
                (h_counter <= value_x[729:720] + 2 && h_counter >= value_x[729:720] - 2 && v_counter <= value_y[729:720] + 2 && v_counter >= value_y[729:720] - 2) ||
                (h_counter <= value_x[739:730] + 2 && h_counter >= value_x[739:730] - 2 && v_counter <= value_y[739:730] + 2 && v_counter >= value_y[739:730] - 2) ||
                (h_counter <= value_x[749:740] + 2 && h_counter >= value_x[749:740] - 2 && v_counter <= value_y[749:740] + 2 && v_counter >= value_y[749:740] - 2) ||
                (h_counter <= value_x[759:750] + 2 && h_counter >= value_x[759:750] - 2 && v_counter <= value_y[759:750] + 2 && v_counter >= value_y[759:750] - 2) ||
                (h_counter <= value_x[769:760] + 2 && h_counter >= value_x[769:760] - 2 && v_counter <= value_y[769:760] + 2 && v_counter >= value_y[769:760] - 2) ||
                (h_counter <= value_x[779:770] + 2 && h_counter >= value_x[779:770] - 2 && v_counter <= value_y[779:770] + 2 && v_counter >= value_y[779:770] - 2) ||
                (h_counter <= value_x[789:780] + 2 && h_counter >= value_x[789:780] - 2 && v_counter <= value_y[789:780] + 2 && v_counter >= value_y[789:780] - 2) ||
                (h_counter <= value_x[799:790] + 2 && h_counter >= value_x[799:790] - 2 && v_counter <= value_y[799:790] + 2 && v_counter >= value_y[799:790] - 2) ||
                (h_counter <= value_x[809:800] + 2 && h_counter >= value_x[809:800] - 2 && v_counter <= value_y[809:800] + 2 && v_counter >= value_y[809:800] - 2) ||
                (h_counter <= value_x[819:810] + 2 && h_counter >= value_x[819:810] - 2 && v_counter <= value_y[819:810] + 2 && v_counter >= value_y[819:810] - 2) ||
                (h_counter <= value_x[829:820] + 2 && h_counter >= value_x[829:820] - 2 && v_counter <= value_y[829:820] + 2 && v_counter >= value_y[829:820] - 2) ||
                (h_counter <= value_x[839:830] + 2 && h_counter >= value_x[839:830] - 2 && v_counter <= value_y[839:830] + 2 && v_counter >= value_y[839:830] - 2) ||
                (h_counter <= value_x[849:840] + 2 && h_counter >= value_x[849:840] - 2 && v_counter <= value_y[849:840] + 2 && v_counter >= value_y[849:840] - 2) ||
                (h_counter <= value_x[859:850] + 2 && h_counter >= value_x[859:850] - 2 && v_counter <= value_y[859:850] + 2 && v_counter >= value_y[859:850] - 2) ||
                (h_counter <= value_x[869:860] + 2 && h_counter >= value_x[869:860] - 2 && v_counter <= value_y[869:860] + 2 && v_counter >= value_y[869:860] - 2) ||
                (h_counter <= value_x[879:870] + 2 && h_counter >= value_x[879:870] - 2 && v_counter <= value_y[879:870] + 2 && v_counter >= value_y[879:870] - 2) ||
                (h_counter <= value_x[889:880] + 2 && h_counter >= value_x[889:880] - 2 && v_counter <= value_y[889:880] + 2 && v_counter >= value_y[889:880] - 2) ||
                (h_counter <= value_x[899:890] + 2 && h_counter >= value_x[899:890] - 2 && v_counter <= value_y[899:890] + 2 && v_counter >= value_y[899:890] - 2) ||
                (h_counter <= value_x[909:900] + 2 && h_counter >= value_x[909:900] - 2 && v_counter <= value_y[909:900] + 2 && v_counter >= value_y[909:900] - 2) ||
                (h_counter <= value_x[919:910] + 2 && h_counter >= value_x[919:910] - 2 && v_counter <= value_y[919:910] + 2 && v_counter >= value_y[919:910] - 2) ||
                (h_counter <= value_x[929:920] + 2 && h_counter >= value_x[929:920] - 2 && v_counter <= value_y[929:920] + 2 && v_counter >= value_y[929:920] - 2) ||
                (h_counter <= value_x[939:930] + 2 && h_counter >= value_x[939:930] - 2 && v_counter <= value_y[939:930] + 2 && v_counter >= value_y[939:930] - 2) ||
                (h_counter <= value_x[949:940] + 2 && h_counter >= value_x[949:940] - 2 && v_counter <= value_y[949:940] + 2 && v_counter >= value_y[949:940] - 2) ||
                (h_counter <= value_x[959:950] + 2 && h_counter >= value_x[959:950] - 2 && v_counter <= value_y[959:950] + 2 && v_counter >= value_y[959:950] - 2) ||
                (h_counter <= value_x[969:960] + 2 && h_counter >= value_x[969:960] - 2 && v_counter <= value_y[969:960] + 2 && v_counter >= value_y[969:960] - 2) ||
                (h_counter <= value_x[979:970] + 2 && h_counter >= value_x[979:970] - 2 && v_counter <= value_y[979:970] + 2 && v_counter >= value_y[979:970] - 2) ||
                (h_counter <= value_x[989:980] + 2 && h_counter >= value_x[989:980] - 2 && v_counter <= value_y[989:980] + 2 && v_counter >= value_y[989:980] - 2) ||
                (h_counter <= value_x[999:990] + 2 && h_counter >= value_x[999:990] - 2 && v_counter <= value_y[999:990] + 2 && v_counter >= value_y[999:990] - 2)) begin
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