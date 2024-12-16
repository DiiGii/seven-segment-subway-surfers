`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:28:39 AM
// Design Name: 
// Module Name: player
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


module player(
    input clk,
    input btnL,
    input btnR,
    input rst,
    output reg [2:0] player
    );
    
reg LUsed;
reg RUsed;
    
always @(posedge clk) begin
    if (rst)
        player <= 3'b010;
    else if (btnL & ~btnR) begin
        if (~LUsed) begin
            LUsed <= 1;
            if (player == 3'b010)
                player <= 3'b100;
            else if (player == 3'b001)
                player <= 3'b010;
        end
    end
    else if (btnR & ~btnL) begin
        if (~RUsed) begin
            RUsed <= 1;
            if (player == 3'b100)
                player <= 3'b010;
            else if (player == 3'b010)
                player <= 3'b001;
        end
    end
    
    if (~btnL)
        LUsed <= 0;
    if (~btnR)
        RUsed <= 0;
    
end
    
endmodule
