///////////////////////////////////////////////////////////////////////
//
// comp_core module
//
//    this is the behavioural model of the bicycle computer without pads
//
///////////////////////////////////////////////////////////////////////

`include "options.sv"

module comp_core(

  output SegA,
  output SegB,
  output SegC,
  output SegD,
  output SegE,
  output SegF,
  output SegG,
  output DP,

  output logic [3:0] nDigit,
  
  input nMode, nTrip,
  input nFork, nCrank,

  input Clock, nReset

  );

logic LOCKUP;

//synchrones signal 
logic nFork_tmp_one;
logic nFork_tmp_two;
logic nCrank_tmp_one;
logic nCrank_tmp_two;

logic nMode_tmp_one;
logic nMode_tmp_two;
logic nTrip_tmp_one;
logic nTrip_tmp_two;


timeunit 1ns;
timeprecision 100ps;

/*
always_ff@(posedge Clock, negedge nReset)
    if(!nReset)
      begin
        nFork_tmp_one <= '0;
        nCrank_tmp_one <='0;
        nFork_tmp_two <= '0;
        nCrank_tmp_two <='0;        
      end
    else 
      begin
        nFork_tmp_one <= nFork;
        nFork_tmp_two <= nFork_tmp_one;
        nCrank_tmp_one <= nCrank;
        nCrank_tmp_two <= nCrank_tmp_one;
      end



always_ff@(posedge Clock, negedge nReset) // make the asychron to synchron
    if(!nReset)
      begin
        nMode_tmp_one <='0;
        nMode_tmp_two <='0;
        nTrip_tmp_one <='0;
        nTrip_tmp_two <='0;
      end
    else 
      begin
        nMode_tmp_one <= nMode;
        nMode_tmp_two <= nMode_tmp_one;
        nTrip_tmp_one <= nTrip;
        nTrip_tmp_two <= nTrip_tmp_one;       
      end
*/


arm_soc arm_soc1(.HCLK(Clock),.HRESETn(nReset),.SegA(SegA),.SegB(SegB),.SegC(SegC),.SegD(SegD),
.SegE(SegE),.SegF(SegF),.SegG(SegG),.DP(DP),.nDigit(nDigit),
.nMode(nMode),.nTrip(nTrip),
.nFork(nFork),.nCrank(nCrank),.LOCKUP(LOCKUP));





endmodule
