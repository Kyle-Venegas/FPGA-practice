module moduleName (
  input   i_clk,
  input   i_uart_rx,  // in the UART modules it should be a wire
  output  o_uart_tx,

  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
  //
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G);

  wire        w_rx_dv;
  wire [7:0]  w_rx_byte;
  wire        w_tx_active, w_tx_serial;

  wire w_Segment1_A, w_Segment2_A;
  wire w_Segment1_B, w_Segment2_B;
  wire w_Segment1_C, w_Segment2_C;
  wire w_Segment1_D, w_Segment2_D;
  wire w_Segment1_E, w_Segment2_E;
  wire w_Segment1_F, w_Segment2_F;
  wire w_Segment1_G, w_Segment2_G;

  // 25MHz / 115200 = 217
  UART_RX #(.CLKS_PER_BIT(217)) UART_RX_Inst (
    .i_clk(i_clk),
    .i_rx_serial(i_uart_rx),
    .o_rx_dv(w_rx_dv), 
    .o_rx_byte(w_rx_byte)   
  );

  UART_TX #(.CLKS_PER_BIT(217)) UART_TX_Inst (
    .i_Clock(i_clk),      // i_rst not mapped, most likely only for testbenching
    .i_TX_DV(w_rx_dv),
    .i_TX_Byte(w_rx_byte),
    .o_TX_Active(w_tx_active),
    .o_TX_Serial(w_tx_serial),
    .o_TX_Done()
  );

  // drive UART line high when TX module not active
  // drive line high for TX module state IDLE
  // rx module looking for when i_rx_serial is 1'b0 to start bit
  assign o_uart_tx = w_tx_active ? w_tx_serial : 1'b1;

  Binary_To_7Segment SevenSeg1_Inst (
    .i_clk(i_clk),
    .i_Binary_Num(w_rx_byte[7:4]),
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

  Binary_To_7Segment SevenSeg2_Inst (
    .i_clk(i_clk),
    .i_Binary_Num(w_rx_byte[3:0]),
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