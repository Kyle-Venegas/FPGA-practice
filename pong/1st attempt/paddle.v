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
  // we're doing a rate of 10Hz
  // best practice to always use 32 bit counters?
  parameter  PADDLE_SPEED  = 1250000;
  reg [31:0] speed_counter = 0      ;

  // up / down exclusive input for paddles
  wire w_up_down_input = i_up ^ i_down;
  
  always @(posedge clk ) begin
    if (w_up_down_input == 1'b1) begin
      if (speed_counter == PADDLE_SPEED) 
        speed_counter <= 0;
      else
        speed_counter <= speed_counter + 1;
    end
  end

  // update paddle location

endmodule