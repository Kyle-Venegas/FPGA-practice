// module modifies input hsync and vsync to include front and back porch

module sync_porch #(
  parameter VIDEO_WIDTH = 3,
  parameter TOTAL_COLS  = 3,
  parameter TOTAL_ROWS  = 3,
  parameter ACTIVE_COLS = 2,
  parameter ACTIVE_ROWS = 2)
  (
  input                        clk,
  input                        i_hsync,
  input                        i_vsync,
  input      [VIDEO_WIDTH-1:0] i_r_val,
  input      [VIDEO_WIDTH-1:0] i_g_val,
  input      [VIDEO_WIDTH-1:0] i_b_val,
  output reg                   o_hsync,
  output reg                   o_vsync,
  output reg [VIDEO_WIDTH-1:0] o_r_val,
  output reg [VIDEO_WIDTH-1:0] o_g_val,
  output reg [VIDEO_WIDTH-1:0] o_b_val
  );

  parameter FRONT_HPORCH = 18;
  parameter BACK_HPORCH  = 50;
  parameter FRONT_VPORCH = 10;
  parameter BACK_VPORCH  = 33;

  wire w_hsync, v_sync;
  wire [9:0] w_col_counter;
  wire [9:0] w_row_counter;

  reg [VIDEO_WIDTH-1:0] r_r_val = 0;
  reg [VIDEO_WIDTH-1:0] r_g_val = 0;
  reg [VIDEO_WIDTH-1:0] r_b_val = 0;

  sync_counter #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS))
  UUT (
    .clk          (clk),
    .i_hsync      (i_hsync),
    .i_vsync      (i_vsync),
    .o_hsync      (w_hsync),
    .o_vsync      (w_vsync),
    .o_col_counter(w_col_counter),
    .o_row_counter(w_row_counter)
  );
  
  // h/v sync becomes 1 when counter is in active + porch.
  always @(posedge clk ) begin
    if ((w_col_counter < FRONT_HPORCH + ACTIVE_COLS) || (w_col_counter > TOTAL_COLS - BACK_HPORCH-1)) begin
      o_hsync <= 1'b1;
    end else begin
      o_hsync <= w_hsync;
    end

    if ((w_row_counter < FRONT_VPORCH + ACTIVE_ROWS) || (w_row_counter > TOTAL_ROWS - BACK_VPORCH-1)) begin
      o_vsync <= 1'b1;
    end else begin
      o_vsync <= w_vsync;
    end
  end

  // aligns input video to modded sync pulses
  // necessary because h/vsync is modified in w_h/vsync
  always @(posedge clk ) begin
    r_r_val <= i_r_val;
    r_g_val <= i_g_val;
    r_b_val <= i_b_val;

    o_r_val <= r_r_val;
    o_g_val <= r_g_val;
    o_b_val <= r_b_val;
  end

endmodule