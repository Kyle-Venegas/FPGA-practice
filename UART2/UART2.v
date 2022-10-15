/* Nandland Project 8: UART (Universal Asynchronous Receiver Transmitter)
- UART1 only received, this one will also transmit
- data displayed by 2 digit 7 segment display are ASCII hex characters of key pressed
- this proj takes parallel data (as a byte) and serializes it, gets sent 1 bit at a time to computer
  then is displayed in terminal emulator

Proj desc: create loopback of data sent by computer. Go board receives data from the computer,
display it on two digit 7 segment display, transmit data back to the computer. 
- 115200 baud rate, 8 data bits, no parity, 1 stop bit, no flow control. 

- tx should happen after rx?  */

module UART_TX #(
  parameter CLKS_PER_BIT = 217
) (
  input       i_rst,        // added reset input
  input       i_clk,
  input       i_tx_dv,
  input [7:0] i_tx_byte,
  output reg  o_tx_active,
  output reg  o_tx_serial,
  output reg  o_tx_done
);

  // 4 states for TX => 2 bits
  localparam IDLE         = 2'b00;
  localparam TX_START_BIT = 2'b01;
  localparam TX_DATA_BITS = 2'b10;
  localparam TX_STOP_BIT  = 2'b11;

  reg [2:0]                     r_state;        // same bits of RX
  reg [7:0]  r_clk_count;    // set lim to clk_count
  reg [2:0]                     r_bit_index;
  reg [7:0]                     r_tx_data;

  // TX state machine
  always @(posedge i_clk or negedge i_rst) begin
    if (~i_rst) begin
      r_state <= 3'b000;
    end else begin
      o_tx_done <= 1'b0;
    end

    case (r_state)
      IDLE: begin
        o_tx_serial <= 1'b1;  // drive line high for idle, different from rx_dv
        r_clk_count <= 0;
        r_bit_index <= 0;

        if (i_tx_dv == 1'b1) begin
          o_tx_active <= 1'b1;
          r_tx_data   <= i_tx_byte;
          r_state     <= TX_START_BIT;
        end else
          r_state <= IDLE;
      end

      // send start bit 1'b0 to serial
      TX_START_BIT: begin
        o_tx_serial <= 1'b0;
        
        if (r_clk_count < CLKS_PER_BIT-1) begin
          r_clk_count <= r_clk_count + 1;
          r_state     <= TX_START_BIT;
        end else begin
          r_clk_count <= 0;
          r_state     <= TX_DATA_BITS;
        end
      end

      // wait CLKS_PER_BIT-1 clk cycles for data bits to transfer
      TX_DATA_BITS: begin
        o_tx_serial <= r_tx_data[r_bit_index];

        if (r_clk_count < CLKS_PER_BIT-1) begin
          r_clk_count <= r_clk_count + 1;
          r_state     <= TX_DATA_BITS;
        end else begin
          r_clk_count <= 0;

          if (r_bit_index < 7) begin
            r_bit_index <= r_bit_index + 1;
            r_state     <= TX_DATA_BITS;
          end else begin
            r_bit_index <= 0;
            r_state     <= TX_STOP_BIT;
          end 
        end
      end

      TX_STOP_BIT: begin
        o_tx_serial <= 1'b1;

        if (r_clk_count < CLKS_PER_BIT-1) begin
          r_clk_count <= r_clk_count + 1;
          r_state     <= TX_STOP_BIT;
        end else begin
          o_tx_done   <= 1'b1;
          r_clk_count <= 0;
          r_state     <= IDLE;
          o_tx_active <= 1'b0;
        end
      end

      default:
        r_state <= IDLE;
    endcase
  end
endmodule