// in charge of the game as a whole
// determines what scores
// paddle and ball module is the logic
// game_main in charge of drawing it
module game_main #(
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480) 
  (
  input            clk          ,
  input            i_start      ,
  input            i_switch_1   ,
  input            i_switch_2   ,
  input            i_switch_3   ,
  input            i_switch_4   ,
  input            i_hsync      ,
  input            i_vsync      ,
  output reg       o_hsync      ,
  output reg       o_vsync      ,
  output [3:0]     o_vga_r      ,
  output [3:0]     o_vga_g      ,
  output [3:0]     o_vga_b      );

  // states
  parameter IDLE    = 3'b000;
  parameter RUNNING = 3'b001;
  parameter P1_WINS = 3'b010;
  parameter P2_WINS = 3'b011;
  parameter RESET   = 3'b100;
  reg [2:0] STATE   = IDLE  ;
  wire      w_active= 1'b0  ;

  // sync_counter wires
  wire       w_hsync, w_vsync;
  wire [9:0] w_col_counter, w_row_counter;

  // paddle wires, i/o
  parameter  PADDLE_HEIGHT = 6;
  wire [9:0] w_paddle_y1, w_paddle_y2;
  wire [9:0] w_paddle_1, w_paddle_2;
  wire [5:0] w_col_counter_div, w_row_counter_div;

  // ball wires
  wire [5:0] w_ball_x = 0;
  wire [5:0] w_ball_y = 0;
  wire       w_draw_ball ;

  // vga outputs
  wire w_draw_any;

  // paddle and ball speed for 10 Hz
  // like LED blink: 
  // 1Hz  = 12500000
  // 10Hz = 1250000
  // we're doing a rate of 10Hz
  // best practice to always use 32 bit counters?
  // counter limits speed
  parameter GAME_SPEED   = 1250000; 
  parameter SCORE_TO_WIN = 5      ;
  reg [3:0] r_P1_score   = 0      ;
  reg [3:0] r_P2_score   = 0      ;

  // take only 4 bits from the 10 bits. 640/16 = 40; 480/16 = 30;
  // essentially division
  parameter BOARD_WIDTH  = 40;
  parameter BOARD_HEIGHT = 30;

  sync_counter #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS))
  sync_counter_inst (
    .clk          (clk)          ,
    .i_hsync      (i_hsync)      ,
    .i_vsync      (i_vsync)      ,
    .o_hsync      (w_hsync)      ,
    .o_vsync      (w_vsync)      ,
    .o_col_counter(w_col_counter),
    .o_row_counter(w_row_counter));

  always @(posedge clk ) begin
    o_hsync <= w_hsync;
    o_vsync <= w_vsync;
  end

  assign w_col_counter_div = w_col_counter[9:4];
  assign w_row_counter_div = w_row_counter[9:4];

  paddle #(
    .PADDLE_SPEED     (GAME_SPEED)       ,
    .PLAYER_INDEX     (0)                ,
    .BOARD_HEIGHT     (BOARD_HEIGHT)     ,
    .PADDLE_HEIGHT    (PADDLE_HEIGHT)    )
  P1 (
    .clk              (clk)              ,
    .i_up             (i_switch_1)       ,
    .i_down           (i_switch_2)       ,
    .i_col_counter_div(w_col_counter_div),
    .i_row_counter_div(w_row_counter_div),
    .o_paddle_y       (w_paddle_y1)      ,   // output reg
    .o_draw           (w_paddle_1)       );  // output reg

  paddle #(
    .PADDLE_SPEED     (GAME_SPEED)       ,
    .PLAYER_INDEX     (BOARD_WIDTH-1)    ,
    .BOARD_HEIGHT     (BOARD_HEIGHT)     ,
    .PADDLE_HEIGHT    (PADDLE_HEIGHT)    )
  P2 (
    .clk              (clk)              ,
    .i_up             (i_switch_3)       ,
    .i_down           (i_switch_4)       ,
    .i_col_counter_div(w_col_counter_div),
    .i_row_counter_div(w_row_counter_div),
    .o_paddle_y       (w_paddle_y2)      ,   // output reg
    .o_draw           (w_paddle_2)       );  // output reg

  draw_ball #(
    .BALL_SPEED       (GAME_SPEED)       ,
    .BOARD_WIDTH      (BOARD_WIDTH)      ,
    .BOARD_HEIGHT     (BOARD_HEIGHT)     )
  ball (
    .clk              (clk)              ,
    .i_start          (i_start)          ,
    .i_paddle_y1      (w_paddle_y_1)     ,
    .i_paddle_y2      (w_paddle_y_2)     ,
    .i_col_counter_div(w_col_counter_div),
    .i_row_counter_div(w_row_counter_div),
    .o_draw_ball      (w_draw_ball)      ,
    .o_ball_x         (w_ball_x)         ,   // output reg
    .o_ball_y         (w_ball_y)         );  // output reg

  // state machine
  always @(posedge clk ) begin
    case (STATE)

      IDLE: begin
        if (i_start == 1'b1)
          STATE <= RUNNING;
      end

      RUNNING: begin
        // how does it detect when ball touches edge of screen?
        if (w_ball_x == 0 && (w_ball_y < w_paddle_y1 || w_ball_y > w_paddle_y1 + PADDLE_HEIGHT)) // bottom
          STATE <= P2_WINS;
        else if (w_ball_x == BOARD_WIDTH-1 && (w_ball_y < w_paddle_y2 || w_ball_y > w_paddle_y2 + PADDLE_HEIGHT)) // bottom
          STATE <= P1_WINS;
      end

      P1_WINS: begin
        if (r_P1_score == SCORE_TO_WIN-1)
          r_P1_score <= 0;
        else begin
          r_P1_score <= r_P1_score + 1;
          STATE <= IDLE;
        end
      end

      P2_WINS: begin
        if (r_P2_score == SCORE_TO_WIN-1)
          r_P2_score <= 0;
        else begin
          r_P2_score <= r_P2_score + 1;
          STATE <= IDLE;
        end
      end
      
      default: begin
        STATE <= IDLE;
      end
    endcase
  end

  assign w_active = (STATE == RUNNING) ? 1'b1 : 1'b0;

  assign w_draw_any = w_draw_ball | w_paddle_1 | w_paddle_2;

  assign o_vga_r = w_draw_any ? 4'b1111 : 4'b0000;
  assign o_vga_g = w_draw_any ? 4'b1111 : 4'b0000;
  assign o_vga_b = w_draw_any ? 4'b1111 : 4'b0000;

endmodule