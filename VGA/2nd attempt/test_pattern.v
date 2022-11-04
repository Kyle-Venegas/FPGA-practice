module test_pattern #(
  parameter VIDEO_WIDTH = 3,
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480) 
  (
  input                        clk,
  input                        i_hsync,
  input                        i_vsync,
  input [3:0]                  i_pattern, // from UART
  output reg                   o_hsync,
  output reg                   o_vsync,
  // RGB values, max value is 255 => 2^8 = 256
  output reg [VIDEO_WIDTH-1:0] o_r_val,
  output reg [VIDEO_WIDTH-1:0] o_g_val,
  output reg [VIDEO_WIDTH-1:0] o_b_val
  );

  // patterns: 16 indexes, VIDEO_WIDTH bits wide.
  wire [VIDEO_WIDTH-1:0] r_pattern[0:15];
  wire [VIDEO_WIDTH-1:0] g_pattern[0:15];
  wire [VIDEO_WIDTH-1:0] b_pattern[0:15];

  // sync_counter wires
  wire w_vsync, w_hsync;
  wire [9:0] w_col_counter;
  wire [9:0] w_row_counter;

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

  // pattern 0: disable pattern
  assign r_pattern[0] = 0;
  assign g_pattern[0] = 0;
  assign b_pattern[0] = 0;

  // pattern 1: all red;
  assign r_pattern[1] = (w_Col_Count < ACTIVE_COLS && w_Row_Count < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
  assign g_pattern[1] = 0;
  assign b_pattern[1] = 0;
  
  // pattern 2: all green;
  assign r_pattern[2] = 0;
  assign g_pattern[2] = (w_Col_Count < ACTIVE_COLS && w_Row_Count < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
  assign b_pattern[2] = 0;
  
  // pattern 3: all blue;
  assign r_pattern[3] = 0;
  assign g_pattern[3] = 0;
  assign b_pattern[3] = (w_Col_Count < ACTIVE_COLS && w_Row_Count < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;

  // pattern 4: checkerboard;
  // "^" is bitwise XOR
  assign r_pattern[4] = w_Col_Count[5] ^ w_Row_Count[5] ? {VIDEO_WIDTH{1'b1}} : 0;
  assign g_pattern[4] = r_pattern[4];
  assign b_pattern[4] = r_pattern[4];

  always @(posedge clk ) begin

    case (i_pattern) 
      4'h0 : begin
        o_r_val <= r_pattern[0];
        o_g_val <= g_pattern[0];
        o_b_val <= b_pattern[0];
      end

      4'h1 : begin
        o_r_val <= r_pattern[1];
        o_g_val <= g_pattern[1];
        o_b_val <= b_pattern[1];
      end

      4'h2 : begin
        o_r_val <= r_pattern[2];
        o_g_val <= g_pattern[2];
        o_b_val <= b_pattern[2];
      end

      4'h3 : begin
        o_r_val <= r_pattern[3];
        o_g_val <= g_pattern[3];
        o_b_val <= b_pattern[3];
      end

      4'h4 : begin
        o_r_val <= r_pattern[4];
        o_g_val <= g_pattern[4];
        o_b_val <= b_pattern[4];
      end

      4'h5 : begin
        pass;
      end

      4'h6 : begin
        pass;
      end

      default: begin
        o_r_val <= r_pattern[0];
        o_g_val <= g_pattern[0];
        o_b_val <= b_pattern[0];
      end
    endcase
  end
endmodule