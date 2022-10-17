`timescale 1ns/10ps

module UART_RX_TB ();

  parameter CLKS_PER_BIT  = 217;
  parameter CLK_PERIOD_NS = 40;
  parameter BIT_PERIOD    = 8600;

  reg clk = 0;
  reg serial_stream = 0;

  wire [7:0] rx_byte;

  // has to be a task because of stream must be sent every clock cycle
  task write_byte;
    input [7:0] data;
    integer i;
    begin
      // send start bit
      serial_stream <= 1'b0;
      #(BIT_PERIOD);
      #1000;

      // send byte
      for (i=0; i<8; i=i+1) begin
        serial_stream <= data[i];
        #(BIT_PERIOD);
      end

      // send stop bit
      serial_stream <= 1'b1;
      #(BIT_PERIOD);
    end
  endtask

  UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),         
    .serial_stream(serial_stream),
    .rx_byte(rx_byte),
    .data_valid()
  );

  always #(CLK_PERIOD_NS/2) clk <= !clk;

  initial begin
    @(posedge clk);
    write_byte(8'h37);
    @(posedge clk);

    if (rx_byte == 8'h37)
      $display("Correct byte recvd");
    else
      $display("wrong byte recvd");
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule