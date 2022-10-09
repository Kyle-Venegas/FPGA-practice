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
    parameter CLKS_PER_BIT = 217    
)
(
    input   i_Clk,
    input   i_RX_Serial,        // Serial Data stream
    output  o_RX_DV,            // Stop bit?
    output  [7:0] o_RX_Byte     // 1 byte = 8 bits
);

    // global variable bits for state requirements
    // 5 possible states => 3 bits
    parameter IDLE         = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DATA_BITS = 3'b010;
    parameter RX_STOP_BIT  = 3'b011;
    parameter CLEANUP      = 3'b100;

    reg [2:0] r_SM_Main     = 0;    // SM = State machine: 3 bits for the parameter states
    reg [7:0] r_Clock_Count = 0;    // 2^8 = 256; CLKS_PER_BIT req is 217, our counter
    reg [2:0] r_Bit_Index   = 0:    // 
    reg RX_DV               = 0;    //
    reg [7:0] r_RX_Byte     = 0;

    always @(posedge i_Clk ) begin

        // works like switch-case blocks
        case (r_SM_Main)
            IDLE: begin                     // IDLE case -> send start bit
                r_RX_DV         <= 1'b0;
                r_Clock_Count   <= 0;       // reset counter and index in cases where SM is not idle
                r_Bit_Index     <= 0;

                if (i_RX_Serial == 1'b0) 
                    r_SM_Main <= RX_START_BIT;
                else 
                    r_SM_Main <= IDLE;
            end

            RX_START_BIT: begin             // check middle of start bit
                if (r_Clock_Count == (CLKS_PER_BIT-1)/2) begin  // (CLKS_PER_BIT-1)/2 = middle of a bit. baud rate and freq depedent 
                    if (i_RX_Serial == 1'b0) begin
                        r_Clock_Count   <= 0;               // reset clock counter
                        r_SM_Main       <= RX_DATA_BITS;
                    end else
                        r_SM_Main       <= IDLE;
                end else begin
                    r_Clock_Count <= r_Clock_Count + 1;     // increment counter
                    r_SM_Main     <= RX_START_BIT;
                end
            end
        

            
        endcase
    end

endmodule