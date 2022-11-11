module game_main #(
  parameter TOTAL_COLS  = 800,
  parameter TOTAL_ROWS  = 525,
  parameter ACTIVE_COLS = 640,
  parameter ACTIVE_ROWS = 480) 
  (
  input      clk       ,
  input      i_start   ,
  input      i_switch_1,
  input      i_switch_2,
  input      i_switch_3,
  input      i_switch_4,
  input      i_hsync   ,
  input      i_vsync   ,
  output     o_hsync   ,
  output     o_vsync   ,
  output reg o_vga_r   ,
  output reg o_vga_g   ,
  output reg o_vga_b   );