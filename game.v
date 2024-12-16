`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 10:44:25 AM
// Design Name: 
// Module Name: game
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


module game(
    input btnLeft,
    input btnRight,
    input clk,
    input MISO,
    output [6:0] seg,
    output [3:0] an,
    output SS,
    output MOSI,
    output SCLK
    );
    
    wire rand_bit;
    wire [2:0] obstacle1;
    wire [2:0] obstacle2;
    wire [2:0] obstacle3;
    wire [2:0] obstacle4;
    wire [2:0] player;
    
    wire game_over;
    wire [3:0] second_ones;
    wire [3:0] second_tens;
    wire [3:0] minute_ones;
    wire [3:0] minute_tens;
    
    reg [31:0] counter_fast_hz = 0;
    reg fast_hz = 0;
    reg [31:0] counter_faster_hz = 0;
    reg faster_hz = 0;
    
    parameter clk_hz = 100_000_000;
    parameter div_fast_hz = clk_hz / 500;
    parameter div_faster_hz = clk_hz / 2771;
    
    always @(posedge clk) begin
        counter_fast_hz <= counter_fast_hz + 1;
        if (counter_fast_hz == div_fast_hz / 2 - 1) begin
            counter_fast_hz <= 0;
            fast_hz <= ~fast_hz;
        end
        
        counter_faster_hz <= counter_faster_hz + 1;
        if (counter_faster_hz == div_faster_hz / 2 - 1) begin
            counter_faster_hz <= 0;
            faster_hz <= ~faster_hz;
        end
    end
    
    rng u_rng (
        .clk(clk),
        .start(rst),
        .rand_bit(rand_bit)
    );
    
    obstacles u_obstacles (
        .clk(clk),
        .rst(rst),
        .rand_bit(rand_bit),
        .obstacle1(obstacle1),
        .obstacle2(obstacle2),
        .obstacle3(obstacle3),
        .obstacle4(obstacle4)
    );
    
    display u_display (
        .fast_hz(fast_hz),
        .obstacle1(obstacle1),
        .obstacle2(obstacle2),
        .obstacle3(obstacle3),
        .obstacle4(obstacle4),
        .player(player),
        .second_ones(second_ones),
        .second_tens(second_tens),
        .minute_ones(minute_ones),
        .minute_tens(minute_tens),
        .game_over(game_over),
        .seg(seg),
        .an(an)
    );
    
    player u_player (
        .clk(clk),
        .btnL(btnL),
        .btnR(btnR),
        .rst(rst),
        .player(player)
    );
    
    logic u_logic (
        .fast_hz(fast_hz),
        .rst(rst),
        .player(player),
        .obstacle4(obstacle4),
        .game_over(game_over),
        .second_ones(second_ones),
        .second_tens(second_tens),
        .minute_ones(minute_ones),
        .minute_tens(minute_tens)
    );

     wire SS;
     wire MOSI;
     wire SCLK;

    wire [7:0] sndData;
    wire sndRec;
    wire [39:0] jstkData;
    wire [9:0] xPos;
    wire [9:0] yPos;

    wire btnStart;
    assign xPos = {jstkData[25:24], jstkData[39:32]};
    assign btnStart = jstkData[1];
    assign sndData = 8'b10000000;

    wire btnL;
    wire btnR;
    wire rst;
    wire zero_for_jstk_rst;
    assign zero_for_jstk_rst = 0;
    
    PmodJSTK u_PmodJSTK(
        .CLK(clk),
        .RST(zero_for_jstk_rst),
        .sndRec(faster_hz),
        .DIN(sndData),
        .MISO(MISO),
        .SS(SS),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .DOUT(jstkData)
    );

    debouncer u_debouncer(
        .fast_hz(fast_hz),
        .xPos(xPos),
        .btnStart(btnStart),
        .btnL(btnL),
        .btnR(btnR),
        .rst(rst)
    );

endmodule
