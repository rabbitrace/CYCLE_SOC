// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is incomplete model of an AHB-Lite Slave containing four read/write registers
//   you should fill missing code where you see "** add code here **" below
//
// Number of addressable locations : 4
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Word aligned
//
// Address map :
//   Base addess + 0 : 
//     Read ouput port (oA) register
//     Write ouput port (oA) register
//   Base addess + 4 : 
//     Read ouput port (oB) register
//     Write ouput port (oB) register
//   Base addess + 8 : 
//     Read ouput port (oC) register
//     Write ouput port (oC) register
//   Base addess + 12 : 
//     Read ouput port (oD) register
//     Write ouput port (oD) register


module ahb_custom_interface(

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
  output logic [31:0] oA,
  output logic [31:0] oB,
  output logic [31:0] oC,
  output logic [31:0] oD

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  //control signals are stored in registers
  logic write_enable, read_enable;
  logic [1:0] word_address;
 
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
        word_address <= HADDR[3:2];
     end
    else
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end

  //Act on control signals in the data phase

  // write

  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        oA <= '0;
        oB <= '0;
        oC <= '0;
        oD <= '0;
      end
    else
      begin
        if ( write_enable && (word_address==0) )
          begin
            oA <= HWDATA;
          $display( "oA: ", HWDATA, " @", $time );
          end
        else if ( write_enable && ( word_address == 1 ) )
          begin
            oB <= HWDATA;
          $display( "oB: ", HWDATA, " @", $time );
          end


        else if ( write_enable && ( word_address == 2 ) )
          begin
            oC <= HWDATA;
          $display( "oC: ", HWDATA, " @", $time );
          end
        else if ( write_enable && ( word_address == 3 ) )
          begin
            oD <= HWDATA;
          $display( "oD: ", HWDATA, " @", $time );
          end

      end
//////
  


  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
       case (word_address)

        0 : HRDATA =  oA ;
        1 : HRDATA =  oB ;
        2 : HRDATA =  oC ;
        3 : HRDATA =  oD ;
        
        // this is not synthesized but provides useful debugging information
        // unused address - returns zero
        default : HRDATA = '0;
      endcase
        //$display( "HRDATA: ", HWDATA, " @", $time );
  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations


endmodule


