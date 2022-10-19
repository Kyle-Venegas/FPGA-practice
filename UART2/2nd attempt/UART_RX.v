// 25000000 / 115200 = 217
module UART_RX #(parameter CLKS_PER_BIT = 217) (
  input        clk,
  input        serial_stream,
  output [7:0] rx_byte,
  output       data_valid);

  // state machine
  reg [1:0]  state;
  parameter IDLE      = 2'b00; 
  parameter START_BIT = 2'b01;
  parameter SAMPLING  = 2'b10;
  parameter STOP_BIT  = 2'b11;

  // counter 
  reg [7:0] counter = 0;
  reg [3:0] bit_index = 0;  // byte has 8 indexes
  
  // temp
  reg       r_data_valid = 0;
  reg [7:0] r_rx_byte = 0;

  always @(posedge clk ) begin

    case (state)

      IDLE: begin
        r_data_valid  <= 1'b1;
        counter       <= 0;
        bit_index     <= 0;
        if (serial_stream == 1'b0) begin  // falling edge detected
          state   <= START_BIT;
        end else
          state   <= IDLE;
      end

      START_BIT: begin
        if (counter < (CLKS_PER_BIT-1)/2) begin
          counter <= counter + 1;
          state   <= START_BIT;
        end else begin
          if (serial_stream == 1'b0) begin
            state   <= SAMPLING;
            counter <= 0;
          end else begin
            state   <= IDLE;
          end
        end
      end

      SAMPLING: begin
        if (counter < CLKS_PER_BIT-1) begin
          counter <= counter + 1;
          state   <= SAMPLING;
        end else begin
          r_rx_byte[bit_index] <= serial_stream;
          counter <= 0;
          if (bit_index < 7) begin
            bit_index <= bit_index + 1;
            state     <= SAMPLING;
          end else begin
            state     <= STOP_BIT;
            bit_index <= 0;
          end
        end
      end

      STOP_BIT: begin
        if (counter < CLKS_PER_BIT-1) begin
          counter <= counter + 1;
          state   <= STOP_BIT;
        end else begin
          r_data_valid  <= 1'b1;
          counter       <= 0;
          state         <= IDLE;
        end
      end
      
      default: begin
        state <= IDLE;
      end
    endcase
  end

  assign rx_byte    = r_rx_byte;
  assign data_valid = r_data_valid;

endmodule