module test_pattern #(
  parameter VIDEO_WIDTH = 3,
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480) 
  (
  input                        clk,
  input                        i_hsync,
  input                        i_vsync,
  input [3:0]                  i_pattern, // from UART
  output reg                   o_hsync,
  output reg                   o_vsync,
  // RGB values, max value is 255 => 2^8 = 256
  output reg [VIDEO_WIDTH-1:0] o_r_val,
  output reg [VIDEO_WIDTH-1:0] o_g_val,
  output reg [VIDEO_WIDTH-1:0] o_b_val
  );

  // 5 patterns to select from
  wire [VIDEO_WIDTH-1:0] r_pattern[0:15];
  wire [VIDEO_WIDTH-1:0] g_pattern[0:15];
  wire [VIDEO_WIDTH-1:0] b_pattern[0:15];

  // sync_to_count module
  //
  //
  // register syncs to align w/ output data

  // pattern 0: disable pattern
  assign r_pattern[0] = 0;
  assign g_pattern[0] = 0;
  assign b_pattern[0] = 0;

  // pattern 1: all red;
  assign r_pattern[1] = 
  assign g_pattern[1] = 
  assign b_pattern[1] = 
  
  // pattern 2: all green;
  assign r_pattern[2] = 
  assign g_pattern[2] = 
  assign b_pattern[2] = 
  
  // pattern 3: all blue;
  assign r_pattern[3] = 
  assign g_pattern[3] = 
  assign b_pattern[3] = 
  
endmodule