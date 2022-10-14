`timescale 1ns/10ps // timescale might be trial and error (for proper wave viewing)

`include "UART2.v"

module UART_TB ();

    parameter c_CLKS_PER_BIT    = 217;
    parameter c_CLK_PERIOD_NS   = 40;       // need explanation
    parameter c_BIT_PERIOD      = 8600;     // need explanation

    reg       r_clk = 0;
    reg       r_tx_dv = 0;
    reg       r_rx_serial = 0;
    reg [7:0] r_tx_byte = 0;

    wire        w_tx_active;
    wire        w_uart_line;
    wire        w_tx_serial;
    wire  [7:0] w_rx_byte;

    UART_RX #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT)
    ) UART_RX_INST (
      .i_clk(r_clk),
      .i_rx_serial(w_uart_line),
      .o_rx_dv(w_rx_dv),
      .o_rx_byte(w_rx_byte)
    );

    UART_TX #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT)
    ) UART_TX_INST (
      .i_clk(r_clk),
      .i_tx_dv(r_tx_dv),
      .i_tx_byte(r_tx_byte),
      .o_tx_active(w_tx_active),
      .o_tx_serial(w_tx_serial),
      .o_tx_done()
    );

    assign w_uart_line = w_tx_active ? w_tx_serial : 1'b1;

    always #(c_CLK_PERIOD_NS/2) r_clk <= !r_clk;
    // ~ bit wise op, returns invert of arg
    // ! is logic op, returns single bit

    // main test
    initial begin
      @(posedge r_clk);
      @(posedge r_clk);
      r_tx_dv <= 1'b1;
      r_tx_byte <= 8'h3F;
      @(posedge r_clk);
      r_tx_dv <= 1'b0;

      // check if correct byte was received
      @(posedge w_rx_dv);
      if (w_rx_byte == 8'h3F)
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