/*Nandland Project 7: UART (Universal Asynchronous Receiver Transmitter)
- USB connector provides power, program, and communication via FTDI chip
serial communication via terminal emulator
- UART referred to Serial port, RS-232 interface, COM port
other methods: PCI, PCI-express, USB
UART is the easiest and best to learn w/
UART serial data stream triggers after falling edge of start bit

UART config parameter:
Baud rate            (9600, 19200, 115200, others)
number of data bits  (7, 8)
parity bit           (On, Off)
Stop bits            (0,1,2)
flow control         (none, on hardware)

baud rate = rate which serial data is transmitted
no. of data bits almost always set to 8

UART SERIAL DATA STREAM
Start: looking for falling edge of start bit
sample middle of every bit [7:0] until stop bit is received

project specs:
Baud rate:       115200
no. data bits:   8
parity bit:      off
stop bits:       1
flow control     None

Utilize a state machine to keep track of data being received. 
Center of the bit should be sampled.
When all 8 data bits are received, stop bit needs to be sent.
use center of a bit because it's less likely to see transitions. */

module UART_RX #(
    // clks per bit = Freq of i_clk / baud rate
    //              = 25 MHz / 115200
    //              = 217
    // goes in the top for mapping diff possible testbench clks_per_bit
    // - CLKS_PER_BIT-1 will always be referenced  because of pure 0 bits. 
    // same way 111 max is 7, but total will be 8 because of the zeroes??
    parameter CLKS_PER_BIT = 217    
) (
    input         i_clk,
    input         i_rx_serial,  // Serial Data stream
    output        o_rx_dv,      // DV = Data Valid
    output  [7:0] o_rx_byte     // 1 byte = 8 bits
);

    // global variable bits for state requirements
    // 5 possible states => 3 bits
    parameter IDLE         = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DATA_BITS = 3'b010;
    parameter RX_STOP_BIT  = 3'b011;
    parameter CLEANUP      = 3'b100;

    reg [2:0] o_state     = 0;  // SM = State machine: 3 bits for the parameter states, initialize to IDLE
    reg [7:0] o_clk_count = 0;  // 2^8 = 256; CLKS_PER_BIT req is 217, our counter
    reg [2:0] r_bit_index = 0;  // 2^3 = 8; there's total 8 indexes in the byte

    reg       r_rx_dv   = 0;    // Data Valid
    reg [7:0] r_rx_byte = 0;    // both needs to be put in registers before going in outputs

    always @(posedge i_clk) begin

        // works like switch-case blocks; case doesn't need begin, but needs endcase
        case (o_state)
            IDLE: begin                     // IDLE case -> send start bit
                r_rx_dv         <= 1'b0;
                o_clk_count     <= 0;       // reset counter and index in cases where SM is not idle
                r_bit_index     <= 0;       // index of received byte

                if (i_rx_serial == 1'b0)    // start bit received
                    o_state <= RX_START_BIT;
                else 
                    o_state <= IDLE;      // doesn't work like a while loop, must assign again next clk posedge
                    // no increment needed to o_clk_count while IDLE
            end

            RX_START_BIT: begin             // check middle of start bit, not starting to sample yet
                if (o_clk_count == (CLKS_PER_BIT-1)/2) begin  // (CLKS_PER_BIT-1)/2 = middle of a bit. baud rate and freq depedent 
                    if (i_rx_serial == 1'b0) begin
                        o_state       <= RX_DATA_BITS;    // next state: start receiving
                        o_clk_count   <= 0;               // reset clock counter, but we're still situated in the middle
                    end else
                        o_state <= IDLE;                  // false alarm, go back to idle
                end else begin
                    o_clk_count   <= o_clk_count + 1;   // increment counter until middle is found while in RX_START_BIT state
                    o_state       <= RX_START_BIT;        // prog will always go through the else condition b4 getting the middle
                end
            end

            RX_DATA_BITS: begin             // RX_START_BIT confirmed, must wait after CLKS_PER_BIT-1 before sampling
                if (o_clk_count < CLKS_PER_BIT-1) begin   // we're still in middle after RX_START_BIT
                    o_state       <= RX_DATA_BITS;
                    o_clk_count   <= o_clk_count + 1;
                end else begin              // wait over, reset clk, now sample received serial
                    o_clk_count   <= 0;
                    r_rx_byte[r_bit_index]  <= i_rx_serial; // bit is sampled

                    /* must continue to sample the rest of the bits
                    r_bit_index must be incremented next posedge to sample in that location
                    while in RX_DATA_BITS state */
                    if (r_bit_index < 7) begin
                        r_bit_index <= r_bit_index + 1;
                        o_state   <= RX_DATA_BITS;
                    end else begin          // all bits sampled, must go to next state, no going to IDLE
                        r_bit_index <= 0;   // reset position
                        o_state   <= RX_STOP_BIT;
                    end
                end
            end

            RX_STOP_BIT: begin
                if (o_clk_count < CLKS_PER_BIT-1) begin
                    o_state       <= RX_STOP_BIT;
                    o_clk_count   <= o_clk_count+1;
                end else begin
                    r_rx_dv         <= 1'b1;
                    o_clk_count   <= 0;
                    o_state       <= CLEANUP;
                end
            end

            CLEANUP: begin
                o_state   <= IDLE;
                r_rx_dv     <= 1'b0;
            end

            default: 
                o_state <= IDLE;  // should always have a default state because of loop

        endcase
    end

    assign o_rx_dv      = r_rx_dv;
    assign o_rx_byte    = r_rx_byte;

endmodule