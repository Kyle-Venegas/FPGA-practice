module paddle #(
  parameter PLAYER_INDEX    = 0  ,
  parameter BOARD_HEIGHT    = 480,
  parameter c_PADDLE_HEIGHT = 6  )
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
  // counter limits speed
  parameter  PADDLE_SPEED  = 1250000;
  reg [31:0] r_speed_counter = 0      ;

  // up / down exclusive input for paddles
  wire w_up_down_input = i_up ^ i_down;
  
  always @(posedge clk ) begin
    if (w_up_down_input == 1'b1) begin
      if (r_speed_counter == PADDLE_SPEED) begin 
        r_speed_counter <= 0;

        // update up if i_up and top limit not reached
        // down if i_down and bottom limit not reached
        if (i_up == 1'b1 && o_paddle_y != 0)
          o_paddle_y <= o_paddle_y - 1;
        else if (i_down == 1'b1 && o_paddle_y != BOARD_HEIGHT-PADDLE_HEIGHT-1)
          o_paddle_y <= o_paddle_y + 1;

      end else
        r_speed_counter <= r_speed_counter + 1;
    end
  end

  // draw
  always @(posedge clk ) begin
    if (i_col_counter_div == PLAYER_INDEX &&              // draw if on player side
        i_row_counter_div >= o_paddle_y &&                // draw inside paddle
        i_row_counter_div <= o_paddle_y + PADDLE_HEIGHT)  // draw bottom part
      o_draw <= 1'b1;
    else
      o_draw <= 1'b0;
  end

endmodule