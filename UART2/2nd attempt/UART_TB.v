`timescale 1ns/10ps
`include "UART_TX.v"

module UART_TB ();

  parameter CLKS_PER_BIT  = 217;
  parameter CLK_PERIOD_NS = 40;
  parameter BIT_PERIOD    = 8600;
  
  reg clk = 0;
  reg r_rx_dv = 0;

  wire serial_stream = 0;

  UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),
    .serial_stream(serial_stream),
    .rx_byte(),
    .data_valid(r_rx_dv);
  );

  UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST (
    .clk(clk),
    .rx_dv(), 
    .rx_byte(),
    .tx_serial(),
    .tx_active(),
    .tx_done()
  );


endmodule