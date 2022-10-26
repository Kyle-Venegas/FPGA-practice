module sync_to_count #(
  parameter TOTAL_COLS = 800,
  parameter TOTAL_ROWS = 525
  ) (
  input            clk,
  input            i_hsync,
  input            i_vsync,
  output reg       o_hsync = 0,
  output reg       o_vsync = 0,
  output reg [9:0] o_col_counter = 0,
  output reg [9:0] o_row_counter = 0,
  );

  wire frame_start;

  // register syncs to align
  always @(posedge clk ) begin
    
  end