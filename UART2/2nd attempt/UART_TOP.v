module UART_TOP (
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
  output o_Segment2_G
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

  assign o_UART_TX = tx_active ? tx_serial = 1'b1;

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

endmodule