/* Nandland Project 8: UART (Universal Asynchronous Receiver Transmitter)
- UART1 only received, this one will also transmit
- data displayed by 2 digit 7 segment display are ASCII hex characters of key pressed
- this proj takes parallel data (as a byte) and serializes it, gets sent 1 bit at a time to computer
  then is displayed in terminal emulator

Proj desc: create loopback of data sent by computer. Go board receives data from the computer,
display it on two digit 7 segment display, transmit data back to the computer. 
- 115200 baud rate, 8 data bits, no parity, 1 stop bit, no flow control. */

module UART_TX #(
  parameter CLKS_PER_BIT = 217
) (
  input       i_rst,
  input       i_clk,
  input       i_tx_dv,
  input [7:0] i_tx_byte,
  output reg  o_tx_byte,
  output reg  o_tx_active,
  output reg  o_tx_serial,
  output reg  o_tx_done
);
  
endmodule