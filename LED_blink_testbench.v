// testbench file
// spec: 25 MHz
// LEARN ABOUT always block (https://www.chipverify.com/verilog/verilog-always-block)

`timescale 1ns/10ps

module LED_blink_TB (); // just need to reference main module in testbench code

reg r_clk = 1'b0;

// always clk = ~clk;
// never executed, always at 0 time units
//
// always #10 clk = ~clk;
// executes every 10 time units, acting as time delay
// needs #x when testbenching

always #1 r_clk = ~ r_clk;

LED_blink 