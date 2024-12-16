`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 10:39:57 AM
// Design Name: 
// Module Name: display
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


module display(
    input fast_hz,
    input [2:0] obstacle1,
    input [2:0] obstacle2,
    input [2:0] obstacle3,
    input [2:0] obstacle4,
    input [2:0] player,
    input [3:0] second_ones,
    input [3:0] second_tens,
    input [3:0] minute_ones,
    input [3:0] minute_tens,
    input game_over,
    
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    reg [2:0] an_on = 0;
    
    always @(posedge fast_hz) begin
            an_on <= an_on + 1;
            if (an_on == 0) begin
                an <= 4'b0111;
                if (game_over)
                    seg <= seg_val_score(minute_tens);
                else
                    seg <= seg_val(obstacle1);
            end
            else if (an_on == 1) begin
                an <= 4'b1011;
                if (game_over)
                    seg <= seg_val_score(minute_ones);
                else
                    seg <= seg_val(obstacle2);
            end
            else if (an_on == 2) begin
                an <= 4'b1101;
                if (game_over)
                    seg <= seg_val_score(second_tens);
                else
                    seg <= seg_val(obstacle3);
            end
            else begin
                an <= 4'b1110;
                if (game_over)
                    seg <= seg_val_score(second_ones);
                else
                    seg <= seg_val(player | obstacle4);
            end
    end
    
    
    function [6:0] seg_val;
    input [2:0] val;
    begin
        if (val == 0)
            seg_val = 7'b1111111;
        else if (val == 3'b100)
            seg_val = 7'b1110111;
        else if (val == 3'b010)
            seg_val = 7'b0111111;
        else if (val == 3'b001)
            seg_val = 7'b1111110;
        else if (val == 3'b110)
            seg_val = 7'b0110111;
        else if (val == 3'b011)
            seg_val = 7'b0111110;
        else if (val == 3'b101)
            seg_val = 7'b1110110;
        else
            seg_val = 7'b0110110;
    
    end
endfunction;

function [6:0] seg_val_score;
    input [3:0] val;
    begin
        if (val == 0)
            seg_val_score = 7'b1000000;
        else if (val == 1)
            seg_val_score = 7'b1111001;
        else if (val == 2)
            seg_val_score = 7'b0100100;
        else if (val == 3)
            seg_val_score = 7'b0110000;
        else if (val == 4)
            seg_val_score = 7'b0011001;
        else if (val == 5)
            seg_val_score = 7'b0010010;
        else if (val == 6)
            seg_val_score = 7'b0000010;
        else if (val == 7)
            seg_val_score = 7'b1111000;
        else if (val == 8)
            seg_val_score = 7'b0000000;
        else
            seg_val_score = 7'b0010000;
    
    end
endfunction;
    
endmodule
