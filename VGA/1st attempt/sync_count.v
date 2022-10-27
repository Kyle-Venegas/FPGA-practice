// Creates row and col counters to output sync pulses from hsync and vsync pulses.
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
    o_vsync <= i_vsync;
    o_hsync <= i_hsync;
  end

  // track row/col counters
  always @(posedge clk ) begin
    if (frame_start == 1'b1) begin
      o_col_counter <= 0;
      o_row_counter <= 0;
    end else begin
      if (o_col_counter == TOTAL_COLS-1) begin
        if (o_row_counter == TOTAL_ROWS-1) begin
          o_row_counter <= 0;
        end else begin
          o_row_counter <= o_row_counter + 1;
        end
        o_col_counter <= 0;
      end else begin
        o_col_counter <= o_col_counter + 1;
      end
    end
  end
  
  // reset counters on rising edge
  assign frame_start = (~o_vsync & i_vsync);
endmodule