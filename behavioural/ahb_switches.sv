// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is an AHB-Lite Slave containing three read-only locations
//
// Number of addressable locations : 3
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Double Word aligned
//
// Address map :
//   Base addess + 0 : 
//     Read Switches Entered via Button[0]
//   Base addess + 4 : 
//     Read Switches Entered via Button[1]
//   Base addess + 8 : 
//     Read Status of Switches Entered via Buttons
//
// Bits within status register :
//   Bit 1   DataValid[1]
//     (data has been entered via Button[1]
//      this status bit is cleared when this data is read by the bus master)
//   Bit 0   DataValid[0] 
//     (data has been entered via Button[0]
//      this status bit is cleared when this data is read by the bus master)

// For simplicity, this interface supports only 32-bit transfers.
// The most significant 16 bits of the value read will always be 0
// since there are only 16 switches.


module ahb_switches(

  // AHB Global Signals
  input HCLK,
  input HRESETn,

  // AHB Signals from Master to Slave
  input [31:0] HADDR, // With this interface only HADDR[3:2] is used (other bits are ignored)
  input [31:0] HWDATA,
  input [2:0] HSIZE,
  input [1:0] HTRANS,
  input HWRITE,
  input HREADY,
  input HSEL,

  // AHB Signals from Slave to Master
  output logic [31:0] HRDATA,
  output HREADYOUT,

  //Non-AHB Signals
  input [15:0] Switches,
  input [1:0] Buttons

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  // Storage for two different switch values  
  logic [15:0] SwitchData[0:1];

  // Storage for status bits 
  logic [1:0] DataValid;

  // last_buttons is used for simple edge detection  
  logic [1:0] last_buttons;

  //control signals are stored in registers
  logic read_enable;
  logic [1:0] word_address;
 
  logic [31:0] Status;

  //Update the SwitchData values only when the appropriate button is pressed
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        SwitchData[0] <= '0;
        SwitchData[1] <= '0;
        last_buttons <= '0;
        DataValid <= 0;
      end
    else
      begin
        if ( Buttons[0] && !last_buttons[0] )
          begin
            SwitchData[0] <= Switches;
            DataValid[0] <= 1;
          end
        else if ( read_enable && ( word_address == 0 ) )
          begin
            DataValid[0] <= 0;
          end


        if ( Buttons[1] && !last_buttons[1] )
          begin
            SwitchData[1] <= Switches;
            DataValid[1] <= 1;
          end
        else if ( read_enable && ( word_address == 1 ) )
          begin
            DataValid[1] <= 0;
          end

        last_buttons <= Buttons;

      end


  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        read_enable <= ! HWRITE;
        word_address <= HADDR[3:2];
     end
    else
      begin
        read_enable <= '0;
        word_address <= '0;
     end

  //Act on control signals in the data phase

  // define the bits in the status register
  assign Status = { 30'd0, DataValid};

  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
      case (word_address)
        0 : HRDATA = SwitchData[0];
        1 : HRDATA = SwitchData[1];
        2 : HRDATA = Status;
        // unused address - returns zero
        default : HRDATA = '0;
      endcase

  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations



endmodule

