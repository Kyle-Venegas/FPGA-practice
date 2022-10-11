// test RX if it receives 0x37 correctly

`timescale 1ns/10ps 
// specifies time unit and time precision of the module that follows it

module UART_RX_TB ();

    parameter c_CLKS_PER_BIT    = 217;
    parameter c_CLK_PERIOD_NS   = 40;       // need explanation
    parameter c_BIT_PERIOD      = 8600;     // need explanation

    reg r_Clock = 0;
    reg r_RX_Serial = 0;

    wire [7:0] w_RX_Byte;

    // task: use when procedure has any timing ctrol constructs, zero/more outputs, 1/more inputs
    task UART_Write_Byte;
        input [7:0] i_Data;
        integer i;
        begin
            // send start bit
            r_RX_Serial <= 1'b0;
            #(c_BIT_PERIOD);
            #1000;

            // send data byte
            for (i=0; i<8; i=i+1) begin
                r_RX_Serial <= i_Data[i];
                #(c_BIT_PERIOD);
            end

            // send stop bit
            r_RX_Serial <= 1'b1;
            #(c_BIT_PERIOD);
            
        end
        
    endtask

endmodule