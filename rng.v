`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 11:24:06 AM
// Design Name: 
// Module Name: rng
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
// rand_bit only changes on the RISING EDGE of the clock. So when clock goes 1->0, the rand_bit value will stay the same. 
//////////////////////////////////////////////////////////////////////////////////


module rng(
    input clk,
    input start,
    output reg rand_bit
    );

reg [30:0] seed = 0;
reg [30:0] lfsr = 0;
    
always @(posedge clk) begin 
    if (start) begin
        if (seed != 0)
            lfsr <= seed;
        else
            lfsr <= 1;
    end
    
    else begin
        lfsr[30:1] <= lfsr[29:0];
        lfsr[0] <= lfsr[27] ^ lfsr[30];
        rand_bit <= lfsr[30];
    end
    seed <= seed + 1;
end
    
endmodule
