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

wire vsync, hsync;

// patterns have 16 indexes
wire [VIDEO_WIDTH-1:0] r_pattern[0:15];
wire [VIDEO_WIDTH-1:0] g_pattern[0:15];
wire [VIDEO_WIDTH-1:0] b_pattern[0:15];

wire [9:0] col_counter;
wire [9:0] row_counter;

wire [6:0] bar_width;
wire [2:0] bar_select;

// sync_count #()

  always @(posedge clk ) begin
    o_hsync <= hsync;
    o_vsync <= vsync;
  end

  // initial
  assign r_pattern[0] = 0;
  assign g_pattern[0] = 0;
  assign b_pattern[0] = 0;

  // pattern 1 all red
  assign r_pattern[1] = (col_counter < ACTIVE_COLS && row_counter < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
  assign g_pattern[1] = 0;
  assign b_pattern[1] = 0;

  // pattern 2 all green
  assign r_pattern[2] = 0;
  assign g_pattern[2] = (col_counter < ACTIVE_COLS && row_counter < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
  assign b_pattern[2] = 0;

  // pattern 3 all blue
  assign r_pattern[3] = 0;
  assign g_pattern[3] = 0;
  assign b_pattern[3] = (col_counter < ACTIVE_COLS && row_counter < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;

  //pattern 4 checkerboard
  assign r_pattern[4] = col_counter[5] ^ row_counter[5] ? {VIDEO_WIDTH{1'b1}} : 0;
  assign g_pattern[4] = r_pattern[4];
  assign b_pattern[4] = r_pattern[4];

endmodule