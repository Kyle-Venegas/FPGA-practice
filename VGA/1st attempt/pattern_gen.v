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

  sync_count #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS)
    ) UUT (
    .clk(clk),
    .i_hsync,
    .i_vsync,
    .o_hsync,
    .o_vsync,
    .o_col_counter(col_counter),
    .o_row_counter(row_counter)
  );

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

  // pattern 5 color bars
  // truth table:
  // R G B bar_select output color
  // 0 0 0     0      black
  // 0 0 1     1      blue
  // 0 1 0     2      green
  // 0 1 1     3      turquoise
  // 1 0 0     4      red
  // 1 0 1     5      purple
  // 1 1 0     6      yellow
  // 1 1 1     7      white
  assign bar_width = ACTIVE_COLS/8;

  assign bar_select = col_counter < bar_width*1 ? 0 :
                      col_counter < bar_width*2 ? 1 :
                      col_counter < bar_width*3 ? 2 :
                      col_counter < bar_width*4 ? 3 :
                      col_counter < bar_width*5 ? 4 :
                      col_counter < bar_width*6 ? 5 :
                      col_counter < bar_width*7 ? 6 : 7;

  // implement truth table above w/ conditional assigns
  assign r_pattern[5] = (bar_select == 4 || bar_select == 5 || bar_select == 6 || bar_select == 7) 
                        ? {VIDEO_WIDTH{1'b1}} : 0;

  assign g_pattern[5] = (bar_select == 2 || bar_select == 3 || bar_select == 6 || bar_select == 7) 
                        ? {VIDEO_WIDTH{1'b1}} : 0;

  assign b_pattern[5] = (bar_select == 1 || bar_select == 3 || bar_select == 5 || bar_select == 7) 
                        ? {VIDEO_WIDTH{1'b1}} : 0;

  // pattern 6 black w/ white border 2px wide
  assign r_pattern[6] = (row_counter <= 1 || row_counter >= ACTIVE_ROWS-1-1 ||
                         col_counter <= 1 || col_counter >= ACTIVE_COLS-1-1) ?
                        {VIDEO_WIDTH{1'b1}} : 0;
  assign g_pattern[6] = r_pattern[6];
  assign b_pattern[6] = r_pattern[6];

  // test pattern selection
  always @(posedge clk ) begin
    case (i_pattern) // byte from UART

      4'h0: begin
        o_r_val <= r_pattern[0];
        o_g_val <= g_pattern[0];
        o_b_val <= b_pattern[0];
      end
      4'h1: begin
        o_r_val <= r_pattern[1];
        o_g_val <= g_pattern[1];
        o_b_val <= b_pattern[1];
      end
      4'h2: begin
        o_r_val <= r_pattern[2];
        o_g_val <= g_pattern[2];
        o_b_val <= b_pattern[2];
      end
      4'h3: begin
        o_r_val <= r_pattern[3];
        o_g_val <= g_pattern[3];
        o_b_val <= b_pattern[3];
      end
      4'h4: begin
        o_r_val <= r_pattern[4];
        o_g_val <= g_pattern[4];
        o_b_val <= b_pattern[4];
      end
      4'h5: begin
        o_r_val <= r_pattern[5];
        o_g_val <= g_pattern[5];
        o_b_val <= b_pattern[5];
      end
      4'h6: begin
        o_r_val <= r_pattern[6];
        o_g_val <= g_pattern[6];
        o_b_val <= b_pattern[6];
      end
      4'h7: begin
        o_r_val <= r_pattern[7];
        o_g_val <= g_pattern[7];
        o_b_val <= b_pattern[7];
      end

      default: begin
        o_r_val <= r_pattern[0];
        o_g_val <= g_pattern[0];
        o_b_val <= b_pattern[0];
      end
    endcase
  end
endmodule