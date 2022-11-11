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

  paddle #(
  ) 
  P1 (
  );

  
















endmodule