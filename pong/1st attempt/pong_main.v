module pong_main (
  input   i_clk,
  input   i_Switch_1,
  input   i_Switch_2,
  input   i_Switch_3,
  input   i_Switch_4,
  input   i_UART_RX,
  output  o_VGA_HSync,
  output  o_VGA_VSync,
  output  o_VGA_Red_0,
  output  o_VGA_Red_1,
  output  o_VGA_Red_2,
  output  o_VGA_Grn_0,
  output  o_VGA_Grn_1,
  output  o_VGA_Grn_2,
  output  o_VGA_Blu_0,
  output  o_VGA_Blu_1,
  output  o_VGA_Blu_2);

  // VGA parameters
  parameter TOTAL_COLS  = 800;
  parameter TOTAL_ROWS  = 525;
  parameter ACTIVE_COLS = 800;
  parameter ACTIVE_ROWS = 800;

  // paramaters for game module
  parameter           RGB_BITS = 3;
  wire [RGB_bits-1:0] w_vga_r, w_vga_r_porch;
  wire [RGB_bits-1:0] w_vga_g, w_vga_g_porch;
  wire [RGB_bits-1:0] w_vga_b, w_vga_b_porch;

  debounce_switch switch_1 (
    .clk(i_clk),
    .i_switch(i_Switch_1),
    .o_switch(w_switch_1));

  debounce_switch switch_2 (
    .clk(i_clk),
    .i_switch(i_Switch_2),
    .o_switch(w_switch_2));

  debounce_switch switch_3 (
    .clk(i_clk),
    .i_switch(i_Switch_3),
    .o_switch(w_switch_3));

  debounce_switch switch_4 (
    .clk(i_clk),
    .i_switch(i_Switch_4),
    .o_switch(w_switch_4));

  UART_RX #(.CLKS_PER_BIT(217)) UART_RX_Inst (
    .clk,         (i_clk), 
    .serial_stream(i_UART_RX),
    .rx_byte      (),
    .data_valid   (w_data_valid));

  sync_pulse #(
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS))
  sync_pulse_inst (
    .clk(i_clk),
    .o_hsync(w_hsync),
    .o_vsync(w_vsync),
    .o_col_counter(),
    .o_row_counter());

  game_main #(
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)) 
  game_main_inst (
    .clk        (i_clk),
    .i_start    (w_data_valid),
    .i_switch_1 (w_switch_1),
    .i_switch_2 (w_switch_2),
    .i_switch_3 (w_switch_3),
    .i_switch_4 (w_switch_4),
    .i_hsync    (w_hsync),
    .i_vsync    (w_vsync),
    .o_hsync    (w_hsync_game),
    .o_vsync    (w_vsync_game),
    .o_vga_r    (w_vga_r),    // output reg
    .o_vga_g    (w_vga_g),
    .o_vga_b    (w_vga_b));

  sync_porch #(
    .VIDEO_WIDTH(RGB_BITS),
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)) 
  sync_porch_inst (
    .clk    (i_clk),
    .i_r_val(w_vga_r),
    .i_g_val(w_vga_g),
    .i_b_val(w_vga_b),
    .i_hsync(w_hsync_game),
    .i_vsync(w_vsync_game),
    .o_hsync(w_hsync_porch),
    .o_vsync(w_vsync_porch),
    .o_r_val(w_vga_r_porch),
    .o_g_val(w_vga_g_porch),
    .o_b_val(w_vga_b_porch));
  
  assign o_VGA_Red_0 = w_vga_r_porch[0];
  assign o_VGA_Red_1 = w_vga_r_porch[1];
  assign o_VGA_Red_2 = w_vga_r_porch[2];
  
  assign o_VGA_Grn_0 = w_vga_g_porch[0];
  assign o_VGA_Grn_1 = w_vga_g_porch[1];
  assign o_VGA_Grn_2 = w_vga_g_porch[2];

  assign o_VGA_Blu_0 = w_vga_b_porch[0];
  assign o_VGA_Blu_1 = w_vga_b_porch[1];
  assign o_VGA_Blu_2 = w_vga_b_porch[2];
  
endmodule