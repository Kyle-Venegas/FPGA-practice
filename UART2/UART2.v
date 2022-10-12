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
  input       i_rst,        // added reset input
  input       i_clk,
  input       i_tx_dv,
  input [7:0] i_tx_byte,
  output reg  o_tx_byte,
  output reg  o_tx_active,
  output reg  o_tx_serial,
  output reg  o_tx_done
);

  // 4 states => 2 bits
  localparam IDLE         = 2'b00;
  localparam TX_START_BIT = 2'b01;
  localparam TX_DATA_BIT  = 2'b10;
  localparam TX_START_BIT = 2'b11;

  reg [2:0]                     r_state;
  reg [$clog2(CLKS_PER_BIT):0]  r_clk_count;    // set lim to clk_count
  //reg [2:0]                     r_bit_index;
  //reg [7:0]                     r_tx_data;

  always @(posedge i_clk ) begin
    if (~i_rst) begin
      r_state <= 2'b00;
    end


    
  end
  
endmodule