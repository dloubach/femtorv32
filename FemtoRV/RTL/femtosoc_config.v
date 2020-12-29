// Configuration file for femtosoc/femtorv32

/************************* Devices **********************************************************************************/
`define NRV_IO_LEDS         // Mapped IO, LEDs D1,D2,D3,D4 (D5 is used to display errors)
`define NRV_IO_UART       // Mapped IO, virtual UART (USB)
//`define NRV_IO_SSD1351    // Mapped IO, 128x128x64K OLed screen
//`define NRV_IO_MAX7219      // Mapped IO, 8x8 led matrix
//`define NRV_IO_SPI_FLASH  // Mapped IO, SPI flash  
//`define NRV_IO_SPI_SDCARD // Mapped IO, SPI SDCARD
//`define NRV_IO_BUTTONS    // Mapped IO, buttons
//`define NRV_MAPPED_SPI_FLASH // SPI flash mapped in address space
                             // Note: to be able to run code from SPI flash directly, use NRV_MINIRV32 below
                             //   the FSM of the 'mini' is simpler, was easy to add the required wait states there.
                             //   larger cores should use an instr cache + page fault / exceptions to load from SPI flash

/************************* Frequency ********************************************************************************/
`define NRV_FREQ 50       // Frequency in MHz. 
                          // Can overclock it up to 75-80 MHz on the ICEStick and 80-100MHz on ULX3S.
                          // Yosys says OK between 40MHz and 50MHz. 

/************************* RAM **************************************************************************************/
// Quantity of RAM in bytes. Needs to be a multiple of 4. 
// Can be decreased if running out of LUTs (address decoding consumes some LUTs).
// 6K max on the ICEstick
//`define NRV_RAM 393216 // bigger config for ULX3S
//`define NRV_RAM 262144 // default for ULX3S
`define NRV_RAM 6144     // default for ICESTICK (cannot do more !)
//`define NRV_RAM 1024   // small ICESTICK config (to further save LUTs if need be)

//`define NRV_MINIRV32 // Minimalistic configuration, reduces LUT count // PAR: 889 LUTs (Icestick, LEDS, 1KbRAM, 50MHz)
                     // Can execute code stored in SPI flash from 1Mb offset (mapped to address 0x800000)
                     // A bit slower though (4-6 CPIs instead of 2-4 CPIs) ... but supports higher overclocking

`ifndef NRV_MINIRV32 // The options below are not supported by minifemtorv32

/************************* Control and Status Registers *************************************************************/
//`define NRV_CSR         // Uncomment if using something below (counters,...)
//`define NRV_COUNTERS    // Uncomment for instr and cycle counters (won't fit on the ICEStick)
//`define NRV_COUNTERS_64 // ... and uncomment this one as well if you want 64-bit counters

/************************* Instruction set **************************************************************************/
//`define NRV_RV32M       // Uncomment for hardware mul and div support (RV32M instructions). Not supported on IceStick !

/************************* Other ************************************************************************************/
/*
 * For the small ALU (that is, when not using RV32M),
 * comment-out if running out of LUTs (makes shifter faster, 
 * but uses 60-100 LUTs) (inspired by PICORV32). 
 */ 
`define NRV_TWOSTAGE_SHIFTER 

/*
 * Uncomment to systematically latch ALU output, 
 * this augments CPI (from 2 to 3), but may reduce
 * critical path (overclocking to 85-90MHz on IceStick works with OLED display and SPI flash)
 */
//`define NRV_LATCH_ALU
`endif

/************************ Advanced processor configuration ************************************************/

`define NRV_RESET_ADDR 0            // The address the processor jumps to on reset 
// `define NRV_RESET_ADDR 0x800000  // If using NRV_MINIRV32 and mapped SPI Flash, you may want to jump to
                                    // a bootloader or firmware stored there.

/* 
 * Uncomment if the RESET button is wired and active low:
 * (wire a push button and a pullup resistor to 
 * pin 47 or change in nanorv.pcf). 
 */
`ifdef ICE_STICK
//`define NRV_NEGATIVE_RESET 
`endif

`ifdef FOMU
`define NRV_NEGATIVE_RESET
`endif

/************************ Normally you do not need to change anything beyond that point ****************************/

// minirv32 systematically latches ALU (simplifies FSM, lower LUT count)
`ifdef NRV_MINIRV32
 `ifndef NRV_LATCH_ALU
  `define NRV_LATCH_ALU
 `endif
`endif

`ifdef NRV_IO_SPI_FLASH
`define NRV_SPI_FLASH
`endif

`ifdef NRV_MAPPED_SPI_FLASH
`define NRV_SPI_FLASH
`endif

/*
 * On the ECP5 evaluation board, there is already a wired button, active low,
 * wired to the "P4" ball of the ECP5 (see ecp5_evn.lpf)
 */ 
`ifdef ECP5_EVN
`define NRV_NEGATIVE_RESET
`endif

// Toggle FPGA defines (ICE40, ECP5) in function of board defines (ICE_STICK, ECP5_EVN)
// Board defines are set in compilation scripts (makeit_icestick.sh and makeit_ecp5_evn.sh)

`ifdef ICE_STICK
 `define ICE40
`endif

`ifdef ICE_FEATHER
 `define ICE40
`endif

`ifdef FOMU
 `define ICE40
`endif

`ifdef ECP5_EVN
 `define ECP5 
`endif

`ifdef ULX3S
 `define ECP5 
`endif

`default_nettype none // Makes it easier to detect typos !

/******************************************************************************************************************/
