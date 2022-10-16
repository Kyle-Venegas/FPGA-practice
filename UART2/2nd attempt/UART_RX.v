// 25000000 / 115200 = 217
module UART_RX #(parameter CLKS_PER_BIT = 217) (
  input        clk,
  input        serial_stream,
  output [7:0] rx_byte,
  output       data_valid);

  // state machine
  reg       state;
  parameter IDLE      = 1'b00; 
  parameter START_BIT = 1'b01;
  parameter SAMPLING  = 1'b10;
  parameter STOP_BIT  = 1'b11;

  // counter 
  reg [7:0] counter = 0;
  reg [3:0] bit_index = 0;  // byte has 8 indexes
  
  // temp
  reg       r_data_valid = 0;
  reg [7:0] r_rx_byte;

  always @(posedge clk ) begin

    case (state)

      IDLE: begin
        r_data_valid <= 1'b0;
        counter    <= 0;
        bit_index  <= 0;
        if (serial_stream == 1'b0) begin  // falling edge detected
          state   <= START_BIT;
        end else
          state   <= IDLE;
      end

      START_BIT: begin
        if (counter > CLKS_PER_BIT-1/2) begin     // verify if actual start bit in middle
          if (serial_stream == 1'b0)    
            state   <= SAMPLING;
            counter <= 0; // still situated in middle next loop
          else
            state <= IDLE;
        end else
          counter <= counter + 1;
          state   <= START_BIT;
      end

      SAMPLING: begin
        if (counter > CLKS_PER_BIT-1) begin
          counter               <= 0;
          r_rx_byte[bit_index]  <= serial_stream;
          
          if (bit_index < 7) begin
            bit_index <= bit_index + 1;
            state     <= SAMPLING;
          end else begin
            state     <= STOP_BIT;
            bit_index <= 0;
          end   
        end else begin
          counter <= counter + 1;
          state   <= SAMPLING;
        end
      end

      STOP_BIT: begin
        if (counter > CLKS_PER_BIT-1) begin
          if (serial_stream == 1'b1) begin
            state   <= IDLE;
            r_data_valid <= 1'b1;
          end
        end else
          counter <= counter + 1;
          state   <= STOP_BIT;
      end
      
      default: begin
        state <= IDLE;
      end
    endcase
  end

  assign rx_byte    = r_rx_byte;
  assign data_valid = r_data_valid;

endmodule