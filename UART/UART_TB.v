// test RX if it receives 0x37 correctly

`timescale 1ns/10ps 
// specifies time unit and time precision of the module that follows it

module UART_RX_TB ();

    parameter c_CLKS_PER_BIT    = 217;
    parameter c_CLK_PERIOD_NS   = 40;       // need explanation
    parameter c_BIT_PERIOD      = 8600;     // need explanation

    reg r_Clk = 0;
    reg r_RX_Serial = 0;

    wire [7:0] w_RX_Byte;

    // task: use when procedure has any timing ctrl constructs, zero/more outputs, 1/more inputs
    // does not have to return anything
    // works like a function written in the same file, not like modules
    // takes in byte in hex, serializes it, passes it 1 by 1
    task UART_Write_Byte;
        input [7:0] i_Data;
        begin
            // send start bit
            r_RX_Serial <= 1'b0;
            #(c_BIT_PERIOD);
            #1000;

            // send data byte
            for (int i=0; i<8; i++) begin
                r_RX_Serial <= i_Data[i];
                #(c_BIT_PERIOD)
            end

            // send stop bit
            r_RX_Serial <= 1'b1;
            #(c_BIT_PERIOD);
        end
    endtask

    UART_RX #(
        .CLKS_PER_BIT(c_CLKS_PER_BIT)
    ) (
        .i_Clk(r_Clk),
        .i_RX_Serial(r_RX_Serial),
        .o_RX_DV(),
        .o_RX_Byte(w_RX_Byte)
    );

    always #(c_CLK_PERIOD_NS/2) r_Clk <= !r_Clk;
    // ~ bit wise op, returns invert of arg
    // ! is logic op, returns single bit

    // main test
    initial begin
        // send command to UART, sends ONE, 
        @(posedge r_Clk);
        UART_WRITE_BYTE(8'h72); // sends byte 37 in hex, passed in as arg
        @(posedge r_Clk);

        // check if correct byte was received
        if (w_RX_Byte == 8'h37)
            $display("Correct byte received");
        else
            $display("Wrote byte received")
        $finish();
    end

    initial begin
        // dump signals to EPWave
        $dumpfile("dump.vcd");
        $dumpvars();
    end

endmodule