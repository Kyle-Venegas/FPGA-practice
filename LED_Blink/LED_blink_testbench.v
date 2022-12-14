// testbench file
// spec: 25 MHz
// LEARN ABOUT always block (https://www.chipverify.com/verilog/verilog-always-block)

module LED_blink_TB (); // no inputs/outputs

    reg r_clk = 1'b0;

    // always clk = ~clk;
    // never executed, always at 0 time units
    //
    // always #10 clk = ~clk;
    // executes every 10 time units, acting as time delay
    // needs #x when testbenching

    always #1 r_clk = ~r_clk;

    LED_blink 
    #(
       .g_COUNT_10HZ(5),
       .g_COUNT_5HZ(10),
       .g_COUNT_2HZ(25),
       .g_COUNT_1HZ(50)
    ) LED_blink_inst
    (
    .i_clk(r_clk),
    .o_LED_1(),     // no need to map it, we just need the signals
    .o_LED_2(),
    .o_LED_4(),
    .o_LED_4()
    );

    initial begin
        $display("Starting testbench...");
        #200;
        $finish();
    end

    initial begin
        // to dump signals to EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule