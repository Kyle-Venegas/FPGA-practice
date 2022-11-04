// timing H:
// tot: 800
// active: 640
// 800 - 640 = 160px

module sync_pulse #(
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480) 
  (
  input            clk,
  output           o_hsync,
  output           o_vsync,
  output reg [9:0] o_col_counter = 0,
  output reg [9:0] o_row_counter = 0
  );
  
/* due to FPGA's procedural nature to the clock,
   the code below will not work. Code would have 
   worked if this was a while loop
   first output would have been col: 1, row: 1
   which would have been wrong */ 
//  always @(posedge clk ) begin
//    if (o_col_counter < TOTAL_COLS-1) begin
//      if (o_row_counter < TOTAL_ROWS-1) begin
//        o_row_counter <= o_row_counter + 1;
//      end else begin
//        o_row_counter <= 0;
//      end
//      o_col_counter <= o_col_counter + 1;
//    end else begin
//      o_col_counter <= 0;
//    end
//  end

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

  assign o_hsync = o_col_counter < ACTIVE_COLS ? 1'b1 : 1'b0;
  assign o_vsync = o_row_counter < ACTIVE_ROWS ? 1'b1 : 1'b0;

endmodule