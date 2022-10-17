module UART_TOP (
  input  clk,
  input  serial_stream,
  // seg1 = upper
  output Segment1_A,
  output Segment1_B,
  output Segment1_C,
  output Segment1_D,
  output Segment1_E,
  output Segment1_F,
  output Segment1_G,
  // seg2 = lower
  output Segment2_A,
  output Segment2_B,
  output Segment2_C,
  output Segment2_D,
  output Segment2_E,
  output Segment2_F,
  output Segment2_G);

  wire        rx_data_valid;
  wire [7:0]  rx_byte;

  wire w_Segment1_A, w_Segment2_A;
  wire w_Segment1_B, w_Segment2_B;
  wire w_Segment1_C, w_Segment2_C;
  wire w_Segment1_D, w_Segment2_D;
  wire w_Segment1_E, w_Segment2_E;
  wire w_Segment1_F, w_Segment2_F;
  wire w_Segment1_G, w_Segment2_G;

  UART_RX #(.CLKS_PER_BIT(217)) UART_RX_INST (
    .clk(clk),
    .serial_stream(serial_stream),
    .rx_byte(rx_byte),
    .data_valid(rx_data_valid)
  );

  Binary_To_7Segment SEG1 (
    .i_clk(clk),
    .i_Binary_Num(rx_byte[7:4]),
    .o_Segment_A(w_Segment1_A),
    .o_Segment_B(w_Segment1_B),
    .o_Segment_C(w_Segment1_C),
    .o_Segment_D(w_Segment1_D),
    .o_Segment_E(w_Segment1_E),
    .o_Segment_F(w_Segment1_F),
    .o_Segment_G(w_Segment1_G)
  );

  assign Segment1_A = ~w_Segment1_A;
  assign Segment1_B = ~w_Segment1_B;
  assign Segment1_C = ~w_Segment1_C;
  assign Segment1_D = ~w_Segment1_D;
  assign Segment1_E = ~w_Segment1_E;
  assign Segment1_F = ~w_Segment1_F;
  assign Segment1_G = ~w_Segment1_G;

  Binary_To_7Segment SEG2 (
    .i_clk(clk),
    .i_Binary_Num(rx_byte[3:0]),
    .o_Segment_A(w_Segment2_A),
    .o_Segment_B(w_Segment2_B),
    .o_Segment_C(w_Segment2_C),
    .o_Segment_D(w_Segment2_D),
    .o_Segment_E(w_Segment2_E),
    .o_Segment_F(w_Segment2_F),
    .o_Segment_G(w_Segment2_G)
  );

  assign Segment2_A = ~w_Segment2_A;
  assign Segment2_B = ~w_Segment2_B;
  assign Segment2_C = ~w_Segment2_C;
  assign Segment2_D = ~w_Segment2_D;
  assign Segment2_E = ~w_Segment2_E;
  assign Segment2_F = ~w_Segment2_F;
  assign Segment2_G = ~w_Segment2_G;

endmodule