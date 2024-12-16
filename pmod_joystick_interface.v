`timescale 1ns / 1ps

module pmod_joystick_interface (
input wire clk, // 100 MHz system clock
input wire reset, // Active-high reset
output reg cs, // Chip select for SPI
output reg sclk, // SPI clock
input wire miso, // Master In Slave Out from joystick
output reg [9:0] x_pos, // 10-bit X-axis position
output reg [9:0] y_pos, // 10-bit Y-axis position
output reg btn // Joystick button state
);

// Parameters
localparam IDLE = 2'b00, READ_X = 2'b01, READ_Y = 2'b10, READ_BTN = 2'b11;

// SPI clock divider
reg [7:0] clk_div;
wire spi_clk = clk_div[7]; // Divide 100 MHz to ~390 kHz for SPI communication
always @(posedge clk or posedge reset) begin
if (reset)
clk_div <= 8'b0;
else
clk_div <= clk_div + 1;
end

// FSM state variables
reg [1:0] state;
reg [4:0] bit_count; // Count bits during SPI communication
reg [15:0] shift_reg; // Shift register to collect joystick data

always @(posedge spi_clk or posedge reset) begin
if (reset) begin
state <= IDLE;
cs <= 1'b1; // Chip select idle high
sclk <= 1'b0;
bit_count <= 5'b0;
shift_reg <= 16'b0;
x_pos <= 10'b0;
y_pos <= 10'b0;
btn <= 1'b0;
end else begin
case (state)
IDLE: begin
cs <= 1'b1; // Deactivate chip select
if (clk_div == 8'b0) begin // Initiate a read periodically
cs <= 1'b0; // Activate chip select
state <= READ_X;
bit_count <= 5'b0;
end
end
READ_X: begin
if (bit_count < 16) begin
sclk <= ~sclk; // Toggle SPI clock
if (sclk) begin
shift_reg <= {shift_reg[14:0], miso}; // Read data bit
bit_count <= bit_count + 1;
end
end else begin
x_pos <= shift_reg[9:0]; // Save X position
state <= READ_Y;
bit_count <= 5'b0;
shift_reg <= 16'b0;
end
end
READ_Y: begin
if (bit_count < 16) begin
sclk <= ~sclk; // Toggle SPI clock
if (sclk) begin
shift_reg <= {shift_reg[14:0], miso}; // Read data bit
bit_count <= bit_count + 1;
end
end else begin
y_pos <= shift_reg[9:0]; // Save Y position
state <= READ_BTN;
bit_count <= 5'b0;
shift_reg <= 16'b0;
end
end
READ_BTN: begin
if (bit_count < 16) begin
sclk <= ~sclk; // Toggle SPI clock
if (sclk) begin
shift_reg <= {shift_reg[14:0], miso}; // Read data bit
bit_count <= bit_count + 1;
end
end else begin
btn <= shift_reg[0]; // Save button state
state <= IDLE;
cs <= 1'b1; // Deactivate chip select
end
end
endcase
end
end
endmodule