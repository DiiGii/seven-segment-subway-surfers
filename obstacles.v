`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 10:25:08 AM
// Design Name: 
// Module Name: obstacles
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


module obstacles(
    input clk,
    input rst,
    input rand_bit,
    output reg [2:0] obstacle1 = 0,
    output reg [2:0] obstacle2 = 0,
    output reg [2:0] obstacle3 = 0,
    output reg [2:0] obstacle4 = 0
    );
    
    parameter start_cycles_per_tick = 60_000_000;
    parameter end_cycles_per_tick = 30_000_000;
    
    reg [31:0] counter = 0;
    reg [31:0] cycles_per_tick = start_cycles_per_tick;
    reg [1:0] wait_for_rand = 0;
    reg spawn_empty = 0;
    
    always @(posedge clk) begin
        counter <= counter + 1;
    
        if (rst) begin
            obstacle1 <= 0;
            obstacle2 <= 0;
            obstacle3 <= 0;
            obstacle4 <= 0;
            cycles_per_tick <= start_cycles_per_tick;
        end
        
        else if (counter >= cycles_per_tick - 1) begin
            counter <= 0;
            
            if (cycles_per_tick > end_cycles_per_tick) begin
                cycles_per_tick <= cycles_per_tick - 500_000;
            end
            
            if (spawn_empty) begin
                spawn_empty <= 0;
                obstacle4 <= obstacle3;
                obstacle3 <= obstacle2;
                obstacle2 <= obstacle1;
                obstacle1 <= 0;
            end
            else begin
                spawn_empty <= 1;
                obstacle4 <= obstacle3;
                obstacle3 <= obstacle2;
                obstacle2 <= obstacle1;
                obstacle1[0] <= rand_bit;
                wait_for_rand <= 1;
            end
        end
        
        else if (wait_for_rand > 0) begin
            wait_for_rand <= wait_for_rand + 1;
            if (wait_for_rand == 3) begin
                wait_for_rand <= 0;
                if (obstacle1 == 3'b111)
                    obstacle1 = 0;
            end
            obstacle1[wait_for_rand] <= rand_bit;
            
        end
    end
    
    
endmodule
