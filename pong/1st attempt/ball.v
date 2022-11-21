module draw_ball #(
  parameter BALL_SPEED   = 1250000,
  parameter BOARD_WIDTH  = 40     ,
  parameter BOARD_HEIGHT = 30     )
  (
  input            clk              ,
  input            i_start          ,
  input            i_paddle_y1      ,
  input            i_paddle_y2      ,
  input [5:0]      i_col_counter_div,
  input [5:0]      i_row_counter_div,
  output reg       o_draw_ball      ,
  output reg [5:0] o_ball_x         ,   // output reg
  output reg [5:0] o_ball_y         );  // output reg

  // how does ball know when to bounce off? 
  // how does ball move?

  reg [31:0] r_speed_counter = 0;
  reg [5:0]  r_prev_x        = 0;
  reg [5:0]  r_prev_y        = 0;

  always @(posedge clk ) begin
    if (i_start == 1'b0) begin      // initial position: at middle
      o_ball_x <= BOARD_WIDTH/2     ;
      o_ball_y <= BOARD_HEIGHT/2    ;
      r_prev_x <= BOARD_WIDTH/2  - 1;
      r_prev_y <= BOARD_HEIGHT/2 - 1;
    end else begin
      if (r_speed_counter == GAME_SPEED) begin
        r_speed_counter <= 0;

        // previous location
        r_prev_x <= o_ball_x;
        r_prev_y <= o_ball_y;

        // ball will always go diagonally
        if (o_ball_x > r_prev_x && o_ball_x == BOARD_WIDTH || o_ball_x < r_prev_x && o_ball_x != 0) // cont going left if not on wall
          o_ball_x <= o_ball_x - 1; // go left
        else
          o_ball_x <= o_ball_x + 1; // go right
        
        if (o_ball_y > r_prev_y && o_ball_y == BOARD_HEIGHT || o_ball_y < r_prev_y && o_ball_y != 0)
          o_ball_y <= o_ball_y - 1; // go up
        else
          o_ball_y <= o_ball_y + 1; // go down
      end else
        r_speed_counter <= r_speed_counter + 1;
    end
  end

  always @(posedge clk ) begin
    if (i_col_counter_div == o_ball_x && i_row_counter_div == o_ball_y)
      o_draw_ball <= 1'b1;
    else
      o_draw_ball <= 1'b0;
  end

endmodule