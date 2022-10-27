// sync pulse module for 640x480
module sync_pulse #(
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480,
  ) (
  input            clk,
  output           o_hsync,
  output           o_vsync,
  output reg [9:0] o_col_counter,
  output reg [9:0] o_row_counter
  );
  // 2^9 = 512; 2^10 = 1024

  always @(posedge clk ) begin
    if (o_col_counter == TOTAL_COLS-1) begin
      o_col_counter <= 0;
      if (o_row_counter == TOTAL_ROWS-1) begin
        o_row_counter <= 0;
      end else begin
        o_row_counter <= o_row_counter + 1;
      end
    end else begin
      o_col_counter <= o_col_counter + 1;
    end
  end
  
  // assign syncs bit 1 when in ACTIVE range
  assign o_hsync = o_col_counter < ACTIVE_COLS ? 1'b1 : 1'b0;
  assign o_vsync = o_row_counter < ACTIVE_ROWS ? 1'b1 : 1'b0;

endmodule