`include "sync_count.v"

module pattern_gen #(
  parameter VIDEO_WIDTH = 3,
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480,
  ) (
  input       clk,
  input       i_hsync,
  input       i_vsync,
  input [3:0] i_pattern,
  output reg  o_hsync,
  output reg  o_vsync,
  output reg  [VIDEO_WIDTH-1:0] o_r_val,
  output reg  [VIDEO_WIDTH-1:0] o_g_val,
  output reg  [VIDEO_WIDTH-1:0] o_b_val,
  )




endmodule