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


module ahb_sensor #(parameter COUNTER = 20 ,parameter COUNTER_MAX = 98000 )(

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
  input logic nCrank,
  input logic nFork

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  // Storage for two different switch values  
  //logic [15:0] SwitchData[0:1];
  logic [31:0] SensorData[0:3];
  // Storage for status bits 
  logic [3:0] DataValid;

  // last_buttons is used for simple edge detection  
  //logic [1:0] last_buttons;

  //control signals are stored in registers
  logic read_enable;
  logic write_enable;
  logic [2:0] word_address;
 
  logic [31:0] Status;

  //time cnt
  logic [COUNTER-1:0] cnt_nFork;
  logic en_cnt_nFork;
  logic cnt_full_nFork;

  logic [COUNTER-1:0] cnt_nCrank;
  logic en_cnt_nCrank;
  logic cnt_full_nCrank;


  //logic [31:0] count_nMode;
  //logic [31:0] count_nTrip;
  logic [31:0] count_nFork ; 
  logic [31:0] count_average_nFork;
  logic [31:0] count_average_nCrank;
  logic [31:0] count_time;
  logic [31:0] count_nFork_cycle;
  logic [31:0] count_nCrank_cycle;
  logic [31:0] time_assume;
  




//synchrones signal 
//logic nFork_tmp_one;
//logic nFork_tmp_two;
//logic nCrank_tmp_one;
//logic nCrank_tmp_two;


//detect the previous value 
logic nFork_tmp_three;
logic nCrank_tmp_three;

logic last_nFork;
logic last_nCrank; 

//detect the one cycle 
logic nedge_nCrank;
logic nedge_nFork ;


  enum logic [2:0] {IDEL_nFork,FILTER_nFork} state_nFork;
  enum logic [2:0] {IDEL_nCrank,FILTER_nCrank} state_nCrank;

/*
always_ff@(posedge HCLK, negedge HRESETn)
    if(!HRESETn)
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
*/
      
always_ff@(posedge HCLK, negedge HRESETn)
    if(!HRESETn)
      begin
        nFork_tmp_three <= '0;
        nCrank_tmp_three <='0;
        last_nFork <= '0;
        last_nCrank <='0;        
      end
    else 
      begin
        nFork_tmp_three  <= nFork;
        nCrank_tmp_three <= nCrank;

        last_nFork <= nFork_tmp_three;
        last_nCrank <= nCrank_tmp_three;
      end
 

  assign nedge_nCrank = (!nCrank_tmp_three) & last_nCrank ;  // negede judge 
  assign nedge_nFork = (!nFork_tmp_three) & last_nFork ;     // negede judge 

  always_ff@(posedge HCLK, negedge HRESETn)
     begin
       if(!HRESETn)
	begin
	  state_nFork<= IDEL_nFork;
	  en_cnt_nFork<= '0; 
	  count_nFork <= '0;
          count_average_nFork <= '0;
          count_time <= '0;
          count_nFork_cycle <= '0;
	  time_assume <= '0;

	end
       else 
	begin 
	  case(state_nFork)
	    IDEL_nFork:
		      begin
		       en_cnt_nFork<='1;         //counter begin  to work 
		       state_nFork <= FILTER_nFork;    
		      end
	    FILTER_nFork:
		      begin
			 if(write_enable)
			   begin
			   {en_cnt_nFork,count_nFork,count_time,time_assume} <= '0;
			    state_nFork <= IDEL_nFork;
			   end
		      else if(cnt_full_nFork)      // if time overflow it means the time we caculate below is not useful 
		           begin
				 en_cnt_nFork<= '0; //stop counter 
                                 count_nFork_cycle <= '0;  // cycle time clear
				 time_assume <= '0;
				 count_average_nFork <='0;
				 state_nFork <= IDEL_nFork;
		           end	
		         else if(nedge_nFork)  // before the time overflow the we detect the nedge signal,it means the wheel is rotating 
		           begin
		            en_cnt_nFork<= '0; //stop counter 
		            count_nFork <= count_nFork + 1'b1;  //cycle number add one 
		            count_average_nFork <=  count_nFork_cycle;
			    count_time <=  count_time + time_assume;
                            time_assume <= '0;
		            count_nFork_cycle <= '0; //cycle time clear 
   		          state_nFork <= IDEL_nFork;
		         end		         
			else 
			   begin
		            count_nFork_cycle <= count_nFork_cycle + 1'b1;  //time caculate 
			    time_assume <= time_assume +1'b1;
		            state_nFork <= FILTER_nFork; // go bakc and wait for next negede
			   end
		       end
	   default: state_nFork<= IDEL_nFork;
	   endcase 		
	end     
     end


  always_ff@(posedge HCLK, negedge HRESETn)
     begin
	if(!HRESETn)
	  cnt_nFork <='0;
	else if(en_cnt_nFork)
	  cnt_nFork <= cnt_nFork +1'b1;
        else 
	  cnt_nFork <= '0;
     end


  always_ff@(posedge HCLK, negedge HRESETn) //full_nfork is to dectect whether the counter has reach the count_max value to detect whether it is moving or not
     begin
	if(!HRESETn)
	  cnt_full_nFork <='0; 
	else if(write_enable)
	  cnt_full_nFork <= '0;
	else if(cnt_nFork == COUNTER_MAX)
	  cnt_full_nFork <= '1;
        else 
	  cnt_full_nFork <= '0;
     end


  always_ff@(posedge HCLK, negedge HRESETn)
     begin
       if(!HRESETn)
	begin
	  state_nCrank<= IDEL_nCrank;
	  en_cnt_nCrank<= '0;
          count_nCrank_cycle <= '0;
          count_average_nCrank <= '0;
	end
       else 
	begin
	  case(state_nCrank)
	    IDEL_nCrank:
		begin
		  en_cnt_nCrank<='1;
		  state_nCrank <= FILTER_nCrank;
		end
	    FILTER_nCrank:
		begin
		  if(write_enable)
		    begin
	         	en_cnt_nCrank<= '0;
		        state_nCrank <= IDEL_nCrank;
		    end
		  else if(cnt_full_nCrank)
		   begin
		     en_cnt_nCrank<='0;
                     count_nCrank_cycle <= '0;
		     count_average_nCrank <='0;
		     state_nCrank <= IDEL_nCrank;
		   end	
		  else if(nedge_nCrank)
		    begin
		      en_cnt_nCrank<= '0;
		      count_average_nCrank <=  count_nCrank_cycle; //cycle time in average
		      count_nCrank_cycle <= 0; //cycle time clear 
   		      state_nCrank <= IDEL_nCrank;
		    end
		  else 
		    begin
		    count_nCrank_cycle <= count_nCrank_cycle + 1;  //time caculate 
		    state_nCrank <= FILTER_nCrank;
		    end
		end
	   default: state_nCrank<= IDEL_nCrank;
	   endcase 		
	end     
     end
      

  always_ff@(posedge HCLK, negedge HRESETn)
     begin
	if(!HRESETn)
	  cnt_nCrank <='0;
	else if(en_cnt_nCrank) //if time enable is 
	  cnt_nCrank <= cnt_nCrank +1'b1;
        else 
	  cnt_nCrank <= '0;
     end


  always_ff@(posedge HCLK, negedge HRESETn)
     begin
	if(!HRESETn)
	  cnt_full_nCrank <='0;
	else if(write_enable)
	  cnt_full_nCrank <= '0;
	else if(cnt_nCrank == COUNTER_MAX)
	  cnt_full_nCrank <= '1;
        else 
	  cnt_full_nCrank <= '0;
     end








  always_ff @(posedge HCLK, negedge HRESETn)
   begin
    if(!HRESETn)
      begin
	  SensorData[0] <= '0;
	  SensorData[1] <= '0;
	  SensorData[2] <= '0;
	  SensorData[3] <= '0;
	  DataValid<='0;
      end
    else if(read_enable && ( word_address == 0))
	 DataValid[0] <= 0;
    else if(read_enable && ( word_address == 1))
	 DataValid[1] <= 0;
    else if(read_enable && ( word_address == 2))
	 DataValid[2] <= 0;
    else if(read_enable && ( word_address == 3))
	 DataValid[3] <= 0;
    else 
      begin
	SensorData[0] <= count_nFork;DataValid[0] <= 1;
        SensorData[1] <= count_average_nFork;DataValid[1] <= 1;
        SensorData[2] <= count_average_nCrank;DataValid[2] <= 1;
        SensorData[3] <= count_time;DataValid[3] <= 1;
      end
  
   end






  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        read_enable <= '0;
	write_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
	write_enable <= HWRITE;
        read_enable <= ! HWRITE;
        word_address <= HADDR[4:2];
     end
    else
      begin
	write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end

  //Act on control signals in the data phase

  // define the bits in the status register
 assign Status = { 28'd0, DataValid};

//always_comb
 //$display("Status = %x   @  %t",Status,$time);

  // read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else
      case (word_address)
        0 : HRDATA = SensorData[0];
        1 : HRDATA = SensorData[1];
        2 : HRDATA = SensorData[2];
        3 : HRDATA = SensorData[3];
        4 : HRDATA = Status;
        // unused address - returns zero
        default : HRDATA = '0;
      endcase

  //Transfer Response
  assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations



endmodule

