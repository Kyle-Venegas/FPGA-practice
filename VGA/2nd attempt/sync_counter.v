// outputs row and col counters based on sync inputs

module sync_counter #(
  parameter TOTAL_COLS = 800,
  parameter TOTAL_ROWS = 525)
  (
  input            clk,
  input            i_hsync,
  input            i_vsync,
  output reg       o_hsync = 0,
  output reg       o_vsync = 0,
  // 2^9 = 512, 2^10 = 1024
  output reg [9:0] o_col_counter = 0,
  output reg [9:0] o_row_counter = 0
  );

  always @(posedge clk ) begin
    o_vsync <= i_vsync;
    o_hsync <= i_hsync;
  end

  // detect rising edge of vsync (proper way)
  wire vsync_rising_edge;
  assign vsync_rising_edge <= (!o_vsync & i_vsync);

  always @(posedge clk ) begin
    if (vsync_rising_edge) begin // reset when posedge of vsync detected
      o_col_counter <= 0;
      o_row_counter <= 0;
    end else begin
      if (o_col_counter < TOTAL_COLS-1) begin
        if (o_row_counter < TOTAL_ROWS-1) begin
          o_row_counter <= o_row_counter + 1;
        end else begin
          o_row_counter <= 0;
        end
        o_col_counter <= o_col_counter + 1;
      end else begin
        o_col_counter <= 0;
      end
    end
  end
  
endmodule