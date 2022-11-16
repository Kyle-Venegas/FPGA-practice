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
  input            clk       ,
  input            i_start   ,
  input            i_switch_1,
  input            i_switch_2,
  input            i_switch_3,
  input            i_switch_4,
  input            i_hsync   ,
  input            i_vsync   ,
  output           o_hsync   ,
  output           o_vsync   ,
  output reg [2:0] o_vga_r   ,
  output reg [2:0] o_vga_g   ,
  output reg [2:0] o_vga_b   );

  // states
  parameter IDLE    = 3'b000;
  parameter RUNNING = 3'b001;
  parameter P1_WINS = 3'b010;
  parameter P2_WINS = 3'b011;
  parameter RESET   = 3'b100;
  reg [2:0] STATE   = IDLE  ;

  // sync_counter wires
  wire       w_hsync, w_vsync;
  wire [9:0] w_col_counter, w_row_counter;

  // paddle wires, i/o
  parameter  PADDLE_HEIGHT = 6;
  wire [9:0] w_paddle_y1, w_paddle_y2;
  wire [9:0] w_draw1, w_draw2;
  wire [5:0] w_col_counter_div, w_row_counter_div;

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
    .o_row_counter(w_row_counter))

  always @(posedge clk ) begin
    o_hsync <= w_hsync;
    o_vsync <= w_vsync;
  end

  assign w_col_counter_div = w_col_counter[9:4];
  assign w_row_counter_div = w_row_counter[9:4];

  paddle #(
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
    .o_draw           (w_draw1)          );  // output reg

  paddle #(
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
    .o_draw           (w_draw2)          );  // output reg

  draw_ball #(
    .BOARD_WIDTH      (BOARD_WIDTH)      ,
    .BOARD_HEIGHT     (BOARD_HEIGHT)     )
  ball (
    .clk              (clk)              ,
    .i_paddle_y1      (w_paddle_y_1)     ,
    .i_paddle_y2      (w_paddle_y_2)     ,
    .i_col_counter_div(w_col_counter_div),
    .i_row_counter_div(w_row_counter_div),
    .o_draw_ball      (w_draw_ball)      ,
    .o_draw_x         (w_draw_x)         ,   // output reg
    .o_draw_y         (w_draw_y)         );  // output reg

  // state machine
  always @(posedge clk ) begin
    case (STATE)

      IDLE: begin
        if (i_start == 1'b1) begin
          STATE <= RUNNING;
        end
      end

      RUNNING: begin
        // how does it detect when ball touches edge of screen?
        
      end
      
      default: begin
        STATE <= IDLE;
      end
    endcase
  end














endmodule