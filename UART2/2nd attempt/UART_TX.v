module UART_TX #(parameter CLKS_PER_BIT = 217) (
  input       clk,
  input       rx_dv, // rx module sends out 
  input [7:0] rx_byte,
  output      tx_serial,
  output      tx_active,
  output      tx_done // transfer done, ready for next byte
  );

  // states
  reg [1:0]  state     = 0;
  localparam IDLE      = 2'b00;
  localparam START_BIT = 2'b01;
  localparam STREAMING = 2'b10;
  localparam STOP_BIT  = 2'b11;

  // temp
  reg [7:0] r_rx_byte   = 0;

  //
  reg [$clog2(CLKS_PER_BIT):0] counter   = 0;
  reg [2:0]                    bit_index = 0;

  always @(posedge clk) begin
    case (state) 
      IDLE: begin
        counter   <= 0;
        tx_done   <= 1'b0;
        tx_serial <= 1'b1;  // feed stream 1s

        if (rx_dv == 1'b1) begin // trigger next state when rx_dv detected
          tx_active <= 1'b1;
          r_rx_byte <= rx_byte;
          state     <= START_BIT;
        end else begin
          state <= IDLE;
        end
      end

      START_BIT: begin      // send out start bit until time for next bit
        tx_serial <= 1'b0;
        
        if (counter < CLKS_PER_BIT-1) begin
          counter <= counter + 1;
          state   <= START_BIT;
        end else begin
          counter <= 0;
          state   <= STREAMING;
        end
      end

      STREAMING: begin
        tx_serial <= r_rx_byte[bit_index];

        if (counter < CLKS_PER_BIT-1) begin
          counter <= counter + 1;
          state   <= STREAMING;
        end else begin
          counter <= 0;
          if (bit_index < 7) begin
            bit_index <= bit_index + 1;
            state     <= STREAMING;
          end else begin
            bit_index <= 0;
            state     <= STOP_BIT;
          end
        end
      end

      STOP_BIT: begin // send stop bit out
        tx_serial <= 1'b1;

        if (counter < CLKS_PER_BIT-1) begin
          counter <= counter + 1;
          state   <= STOP_BIT;
        end else begin
          counter <= 0;
          state   <= IDLE;
          bit_index <= 0;
          tx_done   <= 1'b1;
          tx_active <= 1'b0;
        end
      end

      default:
        state <= IDLE;
    endcase 
  end
endmodule