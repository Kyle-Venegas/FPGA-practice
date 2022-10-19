`timescale 1ns/10ps
`include "UART_TX.v"

module UART_TB ();

  parameter CLKS_PER_BIT  = 217;
  parameter CLK_PERIOD_NS = 40;
  parameter BIT_PERIOD    = 8600;
  
  reg clk = 0;

  // RX I/O
  wire       serial_stream = 0;
  wire [7:0] rx_byte       = 0;
  wire       rx_dv         = 0;

  // TX I/O
  wire tx_serial_stream = 0;
  wire tx_active        = 0;

  UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),
    .serial_stream(serial_stream),
    .rx_byte(rx_byte),
    .data_valid(rx_dv);
  );

  UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST (
    .clk(clk),
    .rx_dv(rx_dv), 
    .rx_byte(rx_byte),
    .tx_serial(tx_serial_stream),
    .tx_active(tx_active),
    .tx_done()
  );

  always #(CLK_PERIOD_NS/2) clk <= !clk;

  initial begin

  end

endmodule