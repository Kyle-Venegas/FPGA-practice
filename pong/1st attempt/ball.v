module draw_ball #(
  parameter BALL_SPEED   = 1250000,
  parameter BOARD_WIDTH  = 40     ,
  parameter BOARD_HEIGHT = 30     )
  (
  input            clk              ,
  input            i_paddle_y1      ,
  input            i_paddle_y2      ,
  input [5:0]      i_col_counter_div,
  input [5:0]      i_row_counter_div,
  output           o_draw_ball      ,
  output reg [5:0] o_draw_x         ,   // output reg
  output reg [5:0] o_draw_y         );  // output reg

  reg [31:0] r_speed_counter = 0      ;

endmodule