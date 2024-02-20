// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is an AHB-Lite Slave containing two read/write registers
//
// Number of addressable locations : 2
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Word aligned
//
// Address map :
//   Base addess + 0 : 
//     Read DataOut register
//     Write DataOut register, Copy NextDataValid to DataValid
//   Base addess + 4 : 
//     Read Status register
//     Write NextDataValid register
//
// Bits within status register :
//   Bit 1   NextDataValid
//   Bit 0   DataValid


// In order to update the output, the software should update the NextDataValid
// register followed by the DataOut register.


module ahb_out_led(

  // AHB Global Signals
  input HCLK,
  input HRESETn,

  // AHB Signals from Master to Slave
  input [31:0] HADDR, // With this interface only HADDR[2] is used (other bits are ignored)
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
  output logic SegA,SegB,SegC,SegD,SegE,SegF,SegG,DP,
  output logic [3:0]nDigit
  //output logic DataValid;

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  //control signals are stored in registers
  logic write_enable, read_enable;
  logic word_address;
 
  //logic NextDataValid;
  logic [31:0] Status;
  logic [31:0] DataOut;

  //conter for circle 
  logic [1:0] counter_led;

  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        write_enable <= HWRITE;
        read_enable <= ! HWRITE;
        word_address <= HADDR[2];
     end
    else
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end

    always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        DataOut <= '0;
      end
    else if ( write_enable)
      begin
        DataOut <= HWDATA;
        // this is not synthesized but provides useful debugging information
          //$display( "DataOut: ", HWDATA, " @", $time );
     end 


  always_ff @(posedge HCLK, negedge HRESETn)
    if(! HRESETn) 
      begin
        counter_led <= '0;
      end
    else if(counter_led == 2'd3)
      begin
        counter_led <= '0;
      end
    else 
      counter_led <= counter_led + 1'b1;
  
 
  // define the bits in the status register
  assign Status = { 30'd0, 2'b11};

  
//just for test 
/* always_comb
    case(counter_led) 
      0: begin {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1110,DataOut[7:0]};$display("nDigit111 = %d/n DataOut=%x ",nDigit,DataOut[7:0]); end
      1: begin {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1101,DataOut[15:8]};$display("nDigit222 = %d/n DataOut=%x ",nDigit,DataOut[15:8]);end
      2: begin {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1011,DataOut[23:16]};$display("nDigit333 = %d/n DataOut=%x ",nDigit,DataOut[23:16]);end
      3: begin {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b0111,DataOut[31:24]};$display("nDigit444 = %d/n DataOut=%x ",nDigit,DataOut[31:24]);end
      default:{nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b0000,8'd10};
    endcase
*/

//when submition
/*  always_ff @(posedge HCLK, negedge HRESETn)
    if(!HRESETn)
    begin
      {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b0000,8'b0000_0000};
    end
    else begin
     case(counter_led) 
       0: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b1110,DataOut[7:0]};

       1: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b1101,DataOut[15:8]};

       2: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b1011,DataOut[23:16]};

       3: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b0111,DataOut[31:24]};


       default:{nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}<={4'b0000,8'b0000_0000};
     endcase
    end
*/

  always_comb
     begin
     {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1111,8'b1111_1111};
     case(counter_led) 
       0: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1110,DataOut[7:0]};

       1: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1101,DataOut[15:8]};

       2: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1011,DataOut[23:16]};

       3: {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b0111,DataOut[31:24]};


       default:{nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1111,8'b1111_1111};
     endcase
     end





   /*   if (counter_led <127)
      {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1110,DataOut[7:0]};
      else if (counter_led<254)
     {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1101,DataOut[15:8]};
      else if (counter_led<382)
     {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b1011,DataOut[23:16]};
      else
     {nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b0111,DataOut[31:24]};   


*/
  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
      case (word_address)
        0 : HRDATA = DataOut;
        1 : HRDATA = Status;
        // unused address - returns zero
        default : HRDATA = '0;
      endcase

  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations


endmodule

