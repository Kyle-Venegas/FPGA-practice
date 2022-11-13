module paddle #(
  parameter PLAYER_INDEX  = 0  ,
  parameter BOARD_HEIGHT  = 480)
  (
  input            clk              ,
  input            i_up             ,
  input            i_down           ,
  input [5:0]      i_col_counter_div,
  input [5:0]      i_row_counter_div,
  output reg [5:0] o_paddle_y       ,   // output reg
  output reg       o_draw           );  // output reg
  // o_paddle_y should be an array for the ball to bounce off of

  // how to make paddle move while button is being pressed?

  // like LED blink: 
  // 1Hz  = 12500000
  // 10Hz = 1250000
  parameter PADDLE_SPEED = 1250000;

  

endmodule