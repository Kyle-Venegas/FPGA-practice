module draw_ball #(
  parameter BOARD_WIDTH  = 40,
  parameter BOARD_HEIGHT = 30)
  (
  input  clk              ,
  input  i_paddle_y1      ,
  input  i_paddle_y2      ,
  input  i_col_counter_div,
  input  i_row_counter_div,
  output o_draw_ball      ,
  output o_draw_x         ,   // output reg
  output o_draw_y         );  // output reg


endmodule