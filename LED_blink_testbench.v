// testbench file
// spec: 25 MHz
// LEARN ABOUT always block (https://www.chipverify.com/verilog/verilog-always-block)

`timescale 1ns/10ps

module LED_blink_TB ();

reg r_Clk = 1'b0;

// always clk = ~clk;
// never executed, always at 0 time units
//
// always #10 clk = ~clk;
// executes every 10 time units, acting as time delay
// needs #x when testbenching

always #1 r_Clk = ~r_Clk;

LED_blink 
#(
    .g_COUNT_10HZ(),
    .g_COUNT_5HZ(),
    .g_COUNT_2HZ(),
    .g_COUNT_10HZ()
) LED_blink_inst
(
    .i_Clk(r_Clk),
    .o_LED_1(),
    .o_LED_2(),
    .o_LED_4(),
    .o_LED_4()
);

endmodule