/* VGA project

main diff b/w VGA and other modern is digital vs analog
- Analog - color driven to pixel is determined by voltage level
- Digital - color determined by binary code

control signals are called syncs that tell monitor when to drive each pixel
: Horizontal sync and Vertical sync
  H sync pulse    and V sync pulse controls which rows and columns are in the active area
Top left corner is where the first pixel is displayed. bottom right is the last.
originally, VGA monitors were Cathode ray tubes (CRT). There's a front porch and back porch
- porch allows active area to be shifted around your VGA monitor

HSync high when in active area of frame horizontally, -> Vsync ... 
Areas where both is active is the active area

Colors:
- GO board: no analog output
- color values are RGB

Project Specs:
  - 60 Hz => 60 frames per second
  - project active area of 640 x 480
    - total of 794 x 525 (416,850 pixels)
    - GO board uses 25MHz clock. 416,850 / 25M = 0.01667 seconds per frame
    - 1 frame every 16.67 milliseconds
  - use UART and b27seg module
    - loopback from UART should attach itself to test pattern generator, sync pulse generator and VGA sync porch to VGA display
    - SYNC pulse generator: generate sync pulses for active and inactive area
    - Test pattern generator: where you are in image based on HSync and VSync inputs
    - VGA sync porch: module modifies sync pulses to add in front and back porches req'd to drive VGA display */