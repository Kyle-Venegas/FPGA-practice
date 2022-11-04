`include "sync_pulse.v"
`include "test_pattern.v"
`include "sync_porch.v"

module TB;

  parameter VIDEO_WIDTH = 3;
  parameter TOTAL_COLS  = 10;
  parameter TOTAL_ROWS  = 6;
  parameter ACTIVE_COLS = 8;
  parameter ACTIVE_ROWS = 4;

  wire [VIDEO_WIDTH-1:0] w_r_val;
  wire [VIDEO_WIDTH-1:0] w_g_val;
  wire [VIDEO_WIDTH-1:0] w_b_val;

  reg clk = 1'b0;

  always #20 clk <= ~clk;

  sync_pulse #(
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COL),
    .ACTIVE_ROWS(ACTIVE_ROW))
  sync_pulse_inst (
    .clk           (clk),
    .o_hsync       (w_hsync_in),  // implicit declaration
    .o_vsync       (w_vsync_in),
    .o_col_counter (),
    .o_row_counter ()
  );

  test_pattern #(
    .VIDEO_WIDTH(VIDEO_WIDTH),
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS))
  test_pattern_inst (
    .clk      (clk),
    .i_hsync  (i_hsync_in),
    .i_vsync  (i_vsync_in),
    .i_pattern(4'b0011),  // checkerboard
    .o_hsync  (w_hsync_out),
    .o_vsync  (w_vsync_out),
    .o_r_val  (w_r_val),
    .o_g_val  (w_g_val),
    .o_b_val  (w_b_val)
  );

  initial begin
    #5000;
    $finish();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule