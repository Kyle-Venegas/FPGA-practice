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

  // test variable
  reg [7:0] test_byte;
  reg [7:0] test_dv;

  UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),
    .serial_stream(serial_stream),
    .rx_byte(rx_byte),
    .data_valid(rx_dv);
  );

  UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST (
    .clk(clk),
    .rx_dv(test_dv), 
    .rx_byte(test_byte),
    .tx_serial(tx_serial_stream),
    .tx_active(tx_active),
    .tx_done()
  );

  always #(CLK_PERIOD_NS/2) clk <= !clk;

  assign serial_stream = tx_active ? tx_serial : 1'b1;

  initial begin
    @(posedge clk);
    @(posedge clk);
    test_dv   <= 1'b1;
    test_byte <= 8'h3F;
    @(posedge clk);
    test_dv <= 1'b0;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule