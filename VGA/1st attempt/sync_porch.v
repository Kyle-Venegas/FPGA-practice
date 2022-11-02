// modifies hsync and vsync to include front and back porch.
// porches meant more back when monitors used Cathode Ray tubes to draw 
//  image on screen.
// front and back porch maintained due to convention, not monitor anatomy

// DVI and HDMI being meant for digital signals, porches concept are 
//  removed

module sync_porch #(
  parameter VIDEO_WIDTH = 3,
  parameter TOTAL_COLS  = 3,
  parameter TOTAL_ROWS  = 3,
  parameter ACTIVE_COLS = 3,
  parameter ACTIVE_ROWS = 2
  ) (
  input                        clk,
  input                        i_hsync,
  input                        i_vsync,
  input      [VIDEO_WIDTH-1:0] i_r_val,
  input      [VIDEO_WIDTH-1:0] i_g_val,
  input      [VIDEO_WIDTH-1:0] i_b_val,
  output reg [VIDEO_WIDTH-1:0] o_r_val,
  output reg [VIDEO_WIDTH-1:0] o_g_val,
  output reg [VIDEO_WIDTH-1:0] o_b_val,
  output reg                   o_hsync,
  output reg                   o_vsync
  );

  // porch params
  parameter FRONT_PORCH_HORZ = 18;
  parameter BACK_PORCH_HORZ  = 50;
  parameter FRONT_PORCH_VERT = 10;
  parameter BACK_PORCH_VERT  = 33;

  // wire hsync vsync
  wire hsync;
  wire vsync;

  // counters
  wire [VIDEO_WIDTH-1:0] col_counter;
  wire [VIDEO_WIDTH-1:0] row_counter;

  // temp
  reg [VIDEO_WIDTH-1:0] r_val = 0;
  reg [VIDEO_WIDTH-1:0] g_val = 0;
  reg [VIDEO_WIDTH-1:0] b_val = 0;

  sync_to_count #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS)
    ) UUT (  
    .clk(clk),
    .i_hsync(i_hsync),
    .i_vsync(i_vsync),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_col_counter(col_counter),
    .o_row_counter(row_counter)
  );

  // mods hsync and vsync to include front and back porch
  always @(posedge clk ) begin
    if ((col_counter < FRONT_PORCH_HORZ + ACTIVE_COLS) || 
      (col_counter > TOTAL_COLS - BACK_PORCH_HORZ-1)) begin
      o_hsync <= 1'b1;
    end else begin
      o_hsync <= hsync;
    end
    
    if ((row_counter < FRONT_PORCH_VERT + ACTIVE_ROWS) ||
      (row_counter > TOTAL_ROWS - BACK_PORCH_VERT-1)) begin
      o_vsync <= 1'b1;     
      end else begin
        o_vsync <= vsync;
      end
  end

  // align input vid to modded sync pulses
  // 2 clk cycles of delay
  always @(posedge clk ) begin
    r_val <= i_r_val;
    g_val <= i_g_val;
    b_val <= i_b_val;

    o_r_val <= r_val;
    o_g_val <= g_val;
    o_b_val <= b_val;
  end
endmodule