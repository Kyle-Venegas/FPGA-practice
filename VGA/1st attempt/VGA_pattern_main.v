module VGA_testpatterns_main (
  input  i_clk,
  input  i_UART_RX,
  output o_UART_TX,
  // seg1 = upper
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
  // seg2 = lower
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G,
  // VGA outputs
  output o_VGA_HSync,
  output o_VGA_VSync,
  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,
  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,
  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2
  );

  wire w_Segment1_A, w_Segment2_A;
  wire w_Segment1_B, w_Segment2_B;
  wire w_Segment1_C, w_Segment2_C;
  wire w_Segment1_D, w_Segment2_D;
  wire w_Segment1_E, w_Segment2_E;
  wire w_Segment1_F, w_Segment2_F;
  wire w_Segment1_G, w_Segment2_G;

  // RX Outputs
  wire [7:0]  rx_byte;
  wire        rx_data_valid;

  // TX Outputs
  wire tx_serial;
  wire tx_active;

  // VGA constants
  parameter VIDEO_WIDTH = 3;
  parameter TOTAL_COLS  = 800;
  parameter TOTAL_ROWS  = 525;
  parameter ACTIVE_COLS = 640;
  parameter ACTIVE_ROWS = 480;

  reg [3:0] tp_index = 0;

  // VGA signals
  wire [VIDEO_WIDTH-1:0] w_Red_Video_TP, w_Red_Video_Porch;
  wire [VIDEO_WIDTH-1:0] w_Grn_Video_TP, w_Grn_Video_Porch;
  wire [VIDEO_WIDTH-1:0] w_Blu_Video_TP, w_Blu_Video_Porch;

  UART_RX #(.CLKS_PER_BIT(217)) UART_RX_INST (
    .clk(i_clk),
    .serial_stream(i_UART_RX),
    .rx_byte(rx_byte),
    .data_valid(rx_data_valid)
  );

  UART_TX #(.CLKS_PER_BIT(217)) UART_TX_Inst (
    .clk(i_clk),           
    .rx_dv(rx_data_valid), 
    .rx_byte(rx_byte),
    .tx_serial(tx_serial),
    .tx_active(tx_active),
    .tx_done() 
  );

  assign o_UART_TX = tx_active ? tx_serial : 1'b1;

  Binary_To_7Segment SEG1 (
    .i_clk(i_clk),
    .i_Binary_Num(rx_byte[7:4]),
    .o_Segment_A(w_Segment1_A),
    .o_Segment_B(w_Segment1_B),
    .o_Segment_C(w_Segment1_C),
    .o_Segment_D(w_Segment1_D),
    .o_Segment_E(w_Segment1_E),
    .o_Segment_F(w_Segment1_F),
    .o_Segment_G(w_Segment1_G)
  );

  assign o_Segment1_A = ~w_Segment1_A;
  assign o_Segment1_B = ~w_Segment1_B;
  assign o_Segment1_C = ~w_Segment1_C;
  assign o_Segment1_D = ~w_Segment1_D;
  assign o_Segment1_E = ~w_Segment1_E;
  assign o_Segment1_F = ~w_Segment1_F;
  assign o_Segment1_G = ~w_Segment1_G;

  Binary_To_7Segment SEG2 (
    .i_clk(i_clk),
    .i_Binary_Num(rx_byte[3:0]),
    .o_Segment_A(w_Segment2_A),
    .o_Segment_B(w_Segment2_B),
    .o_Segment_C(w_Segment2_C),
    .o_Segment_D(w_Segment2_D),
    .o_Segment_E(w_Segment2_E),
    .o_Segment_F(w_Segment2_F),
    .o_Segment_G(w_Segment2_G)
  );

  assign o_Segment2_A = ~w_Segment2_A;
  assign o_Segment2_B = ~w_Segment2_B;
  assign o_Segment2_C = ~w_Segment2_C;
  assign o_Segment2_D = ~w_Segment2_D;
  assign o_Segment2_E = ~w_Segment2_E;
  assign o_Segment2_F = ~w_Segment2_F;
  assign o_Segment2_G = ~w_Segment2_G;

  // VGA test patterns
  always @(posedge i_clk ) begin
    if (rx_data_valid == 1'b1) begin
      tp_index <= rx_byte[3:0];
    end
  end

  sync_pulse #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) sync_pulse_inst (
    .clk(i_clk),
    .o_hsync(w_HSync_Start),
    .o_vsync(w_VSync_Start),
    .o_col_counter(),
    .o_row_counter()
  );

  pattern_gen #(
    .VIDEO_WIDTH(VIDEO_WIDTH),
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) pattern_gen_inst (
    .clk      (i_clk),
    .i_hsync  (w_HSync_Start),
    .i_vsync  (w_VSync_Start),
    .i_pattern(tp_index),
    .o_hsync  (w_HSync_TP),
    .o_vsync  (w_VSync_TP),
    .o_r_val  (w_Red_Video_TP),
    .o_g_val  (w_Grn_Video_TP),
    .o_b_val  (w_Blu_Video_TP)
  );

  sync_porch #(
    .VIDEO_WIDTH(VIDEO_WIDTH),
    .TOTAL_COLS (TOTAL_COLS),
    .TOTAL_ROWS (TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) sync_porch_inst (
    .clk    (i_clk),
    .i_hsync(w_HSync_TP),
    .i_vsync(w_VSync_TP),
    .i_r_val(w_Red_Video_TP),
    .i_g_val(w_Grn_Video_TP),
    .i_b_val(w_Blu_Video_TP),
    .o_r_val(w_Red_Video_Porch),
    .o_g_val(w_Grn_Video_Porch),
    .o_b_val(w_Blu_Video_Porch),
    .o_hsync(w_HSync_Porch),
    .o_vsync(w_VSync_Porch)
  );

  assign o_VGA_HSync = w_HSync_Porch;
  assign o_VGA_VSync = w_VSync_Porch;

  assign o_VGA_Red_0 = w_Red_Video_Porch[0];
  assign o_VGA_Red_1 = w_Red_Video_Porch[1];
  assign o_VGA_Red_2 = w_Red_Video_Porch[2];
   
  assign o_VGA_Grn_0 = w_Grn_Video_Porch[0];
  assign o_VGA_Grn_1 = w_Grn_Video_Porch[1];
  assign o_VGA_Grn_2 = w_Grn_Video_Porch[2];
 
  assign o_VGA_Blu_0 = w_Blu_Video_Porch[0];
  assign o_VGA_Blu_1 = w_Blu_Video_Porch[1];
  assign o_VGA_Blu_2 = w_Blu_Video_Porch[2];

endmodule