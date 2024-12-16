`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:52:24 AM
// Design Name: 
// Module Name: logic
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


module logic(
    input fast_hz,
    input rst,
    input [2:0] player,
    input [2:0] obstacle4,
    output reg game_over,
    output reg [3:0] second_ones,
    output reg [3:0] second_tens,
    output reg [3:0] minute_ones,
    output reg [3:0] minute_tens
    );
    
parameter fast_hz_amt = 500;
parameter start_ticks_per_score = fast_hz_amt / 10;
parameter end_ticks_per_score = fast_hz_amt / 50;
parameter ticks_to_change_ticks_per_score = 750;

reg [31:0] counter = 0;
reg [31:0] ticks_per_score = start_ticks_per_score;
reg [31:0] counter_to_change_ticks_per_score = 0;
    
always @(posedge fast_hz) begin
    if (rst) begin
        game_over <= 0;
        second_ones <= 0;
        second_tens <= 0;
        minute_ones <= 0;
        minute_tens <= 0;
        ticks_per_score <= start_ticks_per_score;
        counter <= 0;
        counter_to_change_ticks_per_score <= 0;
    end

    else if (~game_over) begin
        if ((player[0] & obstacle4[0]) | (player[1] & obstacle4[1]) | (player[2] & obstacle4[2])) begin
            game_over <= 1;
        end
    
        counter_to_change_ticks_per_score <= counter_to_change_ticks_per_score + 1;
        if (counter_to_change_ticks_per_score == ticks_to_change_ticks_per_score - 1) begin
            counter_to_change_ticks_per_score <= 0;
            if (ticks_per_score > end_ticks_per_score) begin
                ticks_per_score <= ticks_per_score - 1;
            end
        end
        
        counter <= counter + 1;
        if (counter >= ticks_per_score - 1) begin
            counter <= 0;
        
            if (second_ones == 9) begin
                second_ones <= 0;
                if (second_tens == 9) begin
                    second_tens <= 0;
                    if (minute_ones == 9) begin
                        minute_ones <= 0;
                        if (minute_tens == 9) begin
                            minute_tens <= 0;
                        end else begin
                            minute_tens <= minute_tens + 1;
                        end
                    end else begin
                        minute_ones <= minute_ones + 1;
                    end
                end else begin
                    second_tens <= second_tens + 1;
                end
            end else begin
                second_ones <= second_ones + 1;
            end
        
        end
    end
end
    
endmodule
