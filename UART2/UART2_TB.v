`timescale 1ns/10ps

`include "UART_TX.v"

module UART_TB ();

    parameter c_CLKS_PER_BIT    = 217;
    parameter c_CLK_PERIOD_NS   = 40;       // need explanation
    parameter c_BIT_PERIOD      = 8600;     // need explanation

    reg r_clk = 0;
    reg r_rx_serial = 0;

    wire        w_tx_active;
    wire        w_uart_line;
    wire        w_tx_serial;

    reg   [7:0] r_tx_byte = 0;
    wire  [7:0] w_rx_byte;

    // task: use when procedure has any timing ctrl constructs, zero/more outputs, 1/more inputs
    // does not have to return anything
    // works like a function written in the same file, not like modules
    // takes in byte in hex, serializes it, passes it 1 by 1
//  task UART_Write_Byte;
//      input [7:0] i_Data;
//      integer i;
//      begin
//          // send start bit
//          r_rx_serial <= 1'b0;
//          #(c_BIT_PERIOD);
//          #1000;

//          // send data byte
//          for (i=0; i<8; i=i+1) begin
//              r_rx_serial <= i_Data[i];
//              #(c_BIT_PERIOD);
//          end

//          // send stop bit
//          r_rx_serial <= 1'b1;
//          #(c_BIT_PERIOD);
//      end
//  endtask

    UART_RX #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT)
    ) UART_RX_INST (
      .i_clk(r_clk),
      .i_rx_serial(r_rx_serial),
      .o_rx_dv(),
      .o_rx_byte(w_rx_byte)
    );

    UART_TX #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT)
    ) UART_TX_INST (
      .i_rst,        // added reset input
      .i_clk(r_clk),
      .i_tx_dv,
      .i_tx_byte,
      .o_tx_byte,
      .o_tx_active,
      .o_tx_serial,
      .o_tx_done
    );

    always #(c_CLK_PERIOD_NS/2) r_clk <= !r_clk;
    // ~ bit wise op, returns invert of arg
    // ! is logic op, returns single bit

    // main test
    initial begin
        // send command to UART, sends ONE, 
        @(posedge r_clk);
        UART_Write_Byte(8'h37); // sends byte 37 in hex, passed in as arg
        @(posedge r_clk);       // why trigger posedge twice?

        // check if correct byte was received
        if (w_rx_byte == 8'h37)
            $display("Correct byte received");
        else
            $display("Wrong byte received");
        $finish();
    end

    initial begin
        // dump signals to EPWave
        $dumpfile("dump.vcd");
        $dumpvars();
    end

endmodule