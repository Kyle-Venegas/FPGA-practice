// make 4 LEDs blink at a rate of 10Hz, 5Hz, 2Hz, 1Hz
// needs counters to trigger the toggle

module LED_blink
#(
  parameter g_COUNT_10HZ  = 1250000,
  parameter g_COUNT_5HZ   = 2500000,
  parameter g_COUNT_2HZ   = 6250000,
  parameter g_COUNT_1HZ   = 12500000
)
(
  input       i_clk,
  output reg  o_LED_1 = 0,
  output reg  o_LED_2 = 0,
  output reg  o_LED_3 = 0,
  output reg  o_LED_4 = 0
);

  reg [31:0] r_count_10hz = 0;
  reg [31:0] r_count_5hz = 0;
  reg [31:0] r_count_2hz = 0;
  reg [31:0] r_count_1hz = 0;

  always @(posedge i_clk)
  begin
    if (r_count_10hz == g_COUNT_10HZ)
    begin
      o_LED_1 <= ~o_LED_1;
      r_count_10hz <= 0;
    end
    else 
      r_count_10hz <= r_count_10hz + 1;
  end

  always @(posedge i_clk)
  begin
    if (r_count_5hz == g_COUNT_5HZ)
    begin
      o_LED_2 <= ~o_LED_2;
      r_count_5hz <= 0;
    end
    else 
      r_count_5hz <= r_count_5hz + 1;
  end

  always @(posedge i_clk)
  begin
    if (r_count_2hz == g_COUNT_2HZ)
    begin
      o_LED_3 <= ~o_LED_3;
      r_count_2hz <= 0;
    end
    else 
      r_count_2hz <= r_count_2hz + 1;
  end

  always @(posedge i_clk)
  begin
    if (r_count_1hz == g_COUNT_1HZ)
    begin
      o_LED_4 <= ~o_LED_4;
      r_count_1hz <= 0;
    end
    else 
      r_count_1hz <= r_count_1hz + 1;
  end

endmodule