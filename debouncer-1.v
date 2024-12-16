`timescale 1ns / 1ps

module debouncer(
    input fast_hz,
    input [9:0] xPos,
    input btnStart,
    output reg btnL,
    output reg btnR,
    output reg rst
    );

    parameter range = 1024;
    parameter middle = range  / 2;
    parameter offset = 450;

    always @(posedge fast_hz) begin
        btnR <= (xPos > middle + offset) ? 1 : 0;
        btnL <= (xPos < middle - offset) ? 1 : 0;
        rst <= btnStart;
    end

endmodule