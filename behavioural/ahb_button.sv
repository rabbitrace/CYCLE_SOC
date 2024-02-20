// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is an AHB-Lite Slave containing seven read-only locations
//
// Number of addressable locations : 7
// Size of each addressable location : 32 bits
// Supported transfer sizes : Word
// Alignment of base address : Double Word aligned
//
// Address map :
//   Base addess + 0 : 
//     Read Switches count of press_nTrip
//   Base addess + 4 : 
//     Read Switches count of press_nMode
//   Base addess + 8:
//     Read Swtiches status
//
// Bits within status register :
//      this status bit is cleared when this data is read by the bus master)
//   Bit 1   DataValid[1]
//     (data has been entered by count of button_mode)
//      this status bit is cleared when this data is read by the bus master)
//   Bit 0   DataValid[0] 
//     (data has been entered by count of button_trip)
//      this status bit is cleared when this data is read by the bus master)



module ahb_button #(COUNTER_MAX = 820,BOTH_MAX = 328)(

// AHB Global Signals
input HCLK,
input HRESETn,

// AHB Signals from Master to Slave
input [31:0] HADDR, // With this interface HADDR is ignored
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
input logic nMode,
input logic nTrip
);

timeunit 1ns;
timeprecision 100ps;

//logic [31:0]  press_nMode;  //caculate the times of pressing Mode
//logic [31:0]  press_nTrip;  //caculate the times of pressing Trip


// AHB transfer codes needed in this module
localparam No_Transfer = 2'b0;

  // Storage for two different switch values  
  //logic [15:0] SwitchData[0:1];
logic [31:0] ButtonData[0:2];
// Storage for status bits 
logic [2:0] DataValid;

//control signals are stored in registers
logic read_enable;
logic [1:0] word_address;

logic [31:0] Status;

//detect the button down
logic nedge_nTrip ; 
logic nedge_nMode ;

//detect the button up
logic pose_nTrip ;
logic pose_nMode ;

logic last_nTrip;
logic last_nMode;

//time
logic en_cnt_nTrip;
logic [9:0]cnt_nTrip;
logic en_cnt_nMode;
logic [9:0] cnt_nMode;
logic en_cnt_both;
logic [31:0]cnt_both;

//store the data 

//logic nMode_tmp_one;
//logic nMode_tmp_two;
logic nMode_tmp_three;

//logic nTrip_tmp_one;
//logic nTrip_tmp_two;
logic nTrip_tmp_three;

//cnt_overflow signal 
logic cnt_full_nTrip;
logic cnt_full_nMode;

//press button together 
logic press_button_both;

//press button be pressed other button should not be regard as up
logic fake_nMode;
logic fake_nTrip;


enum logic [2:0] {IDEL_nTrip,FILTER_nTrip,DOWN_nTrip,WAIT_nTrip,UP_nTrip}state_nTrip;
enum logic [2:0] {IDEL_nMode,FILTER_nMode,DOWN_nMode,WAIT_nMode,UP_nMode}state_nMode;

/*
always_ff@(posedge HCLK, negedge HRESETn) // make the asychron to synchron
    if(!HRESETn)
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

always_ff@(posedge HCLK, negedge HRESETn) // get the value of past and now
    if(!HRESETn)
      begin
        last_nTrip <= 1'b0;
        last_nMode <= 1'b0;
        nMode_tmp_three <= 1'b0;
        nTrip_tmp_three <= 1'b0;
      end
    else 
      begin
        nMode_tmp_three <= nMode;
        last_nMode <= nMode_tmp_three;

        nTrip_tmp_three <= nTrip;
        last_nTrip <= nTrip_tmp_three;
      end

assign nedge_nTrip = (!nTrip_tmp_three) & last_nTrip ;
assign nedge_nMode = (!nMode_tmp_three) & last_nMode ;

assign pose_nTrip = nTrip_tmp_three  & (!last_nTrip) ;
assign pose_nMode = nMode_tmp_three  & (!last_nMode) ;


always_ff @(posedge HCLK, negedge HRESETn)
begin 
 if(!HRESETn)
    begin
      //press_nTrip<=0;
      state_nTrip <=IDEL_nTrip;
      en_cnt_nTrip <= '0;
      fake_nTrip <= '0;
    end
 else
    begin
      case(state_nTrip) 
        IDEL_nTrip:
        begin
          //press_nTrip <= 1'b0;
          if(nedge_nTrip) //when first detect the nedge state come into FILTER_nTrip
            begin
              en_cnt_nTrip <= '1; // at this moment we should start cnt 
              state_nTrip <= FILTER_nTrip;
            end
        end
        FILTER_nTrip:
        begin
          if(cnt_full_nTrip)
            begin
               en_cnt_nTrip <= '0; // stop counting 
               if(!last_nTrip)
                begin
                  state_nTrip <= DOWN_nTrip;
                end
               else 
                begin
                  state_nTrip <= IDEL_nTrip;
                end   
            end
          else 
            begin
               state_nTrip <= FILTER_nTrip;
            end
        end
	DOWN_nTrip:
	 begin
	    if(pose_nTrip)
	     begin
		state_nTrip <= WAIT_nTrip;
	        en_cnt_nTrip <= '1;
	     end
            if(press_button_both)
	     begin
               fake_nTrip <= '1;
 	     end
	  end
	WAIT_nTrip:
	  begin
	    if(cnt_full_nTrip)
	      begin
                en_cnt_nTrip <= '0;
		if(last_nTrip)
		  begin
		    state_nTrip <= UP_nTrip;
		  end
		else 
		  begin
                    state_nTrip <= IDEL_nTrip;	
		  end
	      end
	    else 
	      begin
		state_nTrip <= WAIT_nTrip;
	      end
	  end
	UP_nTrip:
	  begin
	     //press_nTrip <= 1'b1; // add the value of button
             //press_nTrip <=press_nTrip + 1'b1;
	     state_nTrip <= IDEL_nTrip;
	     fake_nTrip <='0;
	  end
          default: state_nTrip <= IDEL_nTrip;
      endcase
    end
end

  always_ff@(posedge HCLK, negedge HRESETn)
  	begin
	  if(!HRESETn)
	    cnt_nTrip <='0;
         
	  else if(en_cnt_nTrip)
	    cnt_nTrip <= cnt_nTrip +1'b1;
    	  else 
	    cnt_nTrip <= '0;
  	end
 
  always_ff@(posedge HCLK, negedge HRESETn) //full_nfork is to dectect whether the counter has reach the count_max value to detect whether it is moving or not
  	begin
	  if(!HRESETn)
	    cnt_full_nTrip <='0; 
	  else if(cnt_nTrip >= COUNTER_MAX)
	    cnt_full_nTrip <= '1;
    	  else 
	    cnt_full_nTrip <= '0;
  	end

//press_nMode 
always_ff@(posedge HCLK, negedge HRESETn)
begin 
 if(!HRESETn)
    begin
      en_cnt_nMode <= '0;
      fake_nMode <= '0;
      //press_nMode <= 0 ;
      state_nMode <=IDEL_nMode;
    end
 else
    begin
      case(state_nMode) 
        IDEL_nMode:
        begin
          //press_nMode <= 1'b0; // add the value of button
          if(nedge_nMode) //when first detect the nedge state come into FILTER_nTrip
            begin
              en_cnt_nMode <= '1; // at this moment we should start cnt 
              state_nMode <= FILTER_nMode;
            end
        end
        FILTER_nMode:
        begin
          if(cnt_full_nMode)
            begin
              en_cnt_nMode <= '0;
              if(!last_nMode)
                begin
                  state_nMode <= DOWN_nMode;
                end
              else 
                begin
                  state_nMode <= IDEL_nMode;
                end
            end
            else 
              begin
                state_nMode <= FILTER_nMode;
              end
        end
       DOWN_nMode:
       begin
	 if(pose_nMode)
	  begin
	    state_nMode <= WAIT_nMode;
	    en_cnt_nMode <= '1;
	  end
        if(press_button_both)
	  begin
	    fake_nMode <= '1; 
          end
       end
       WAIT_nMode:
       begin
	 if(cnt_full_nMode)
	   begin
             en_cnt_nMode <= '0;
             if(last_nMode)
	       begin
		 state_nMode <= UP_nMode;
               end
             else 
		begin
		  state_nMode <= IDEL_nMode;		
 		end
   	   end
         else 
	    begin
              state_nMode <= WAIT_nMode;
	    end
       end

       UP_nMode:
       begin
	      //press_nMode <= 1'b1; // add the value of button
              //press_nMode <= press_nMode +1'b1;
	      state_nMode <= IDEL_nMode;
	      fake_nMode <= '0;	
       end
          default: state_nMode <= IDEL_nMode;
      endcase
    end
end


  always_ff@(posedge HCLK, negedge HRESETn)
  begin
	  if(!HRESETn)
	    cnt_nMode <='0;
	  else if(en_cnt_nMode)
	    cnt_nMode <= cnt_nMode +1'b1;
    else 
	    cnt_nMode <= '0;
  end
 

  always_ff@(posedge HCLK, negedge HRESETn) //full_nfork is to dectect whether the counter has reach the count_max value to detect whether it is moving or not
  begin
	    if(!HRESETn)
	    cnt_full_nMode <='0; 
	  else if(cnt_nMode >= COUNTER_MAX)
	    cnt_full_nMode <= '1;
    else 
	    cnt_full_nMode <= '0;
  end



always_ff@(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      begin
        en_cnt_both <= 1'b0;
      end
    else if((state_nTrip == DOWN_nTrip) && (state_nMode == DOWN_nMode))
      begin
       en_cnt_both <= 1'b1;
      end
    else 
       en_cnt_both <= 1'b0;
  end


always_ff@(posedge HCLK, negedge HRESETn)
   if(!HRESETn)
     begin
       cnt_both <= '0;
     end
   else if(en_cnt_both)
       cnt_both <= cnt_both +1'b1;
   else
	cnt_both <= '0;


always_ff@(posedge HCLK, negedge HRESETn)
   if(!HRESETn)
     begin
       press_button_both <= '0;
     end
   else if(cnt_both == BOTH_MAX)
      press_button_both <= 1'b1;
   else 
      press_button_both <= 1'b0;


always_ff @(posedge HCLK, negedge HRESETn)
 begin  
 if(!HRESETn)
   begin
     ButtonData[0] <= '0;
     ButtonData[1] <= '0;
     ButtonData[2] <= '0; 
     DataValid <= '0; 
   end
 else if(read_enable &&(word_address ==0))
	begin
	  ButtonData[0] <= 0;
	  DataValid[0]  <= '0;
	end
 else if(read_enable &&(word_address ==1))
	begin
	  ButtonData[1] <= 0;
	  DataValid[1]  <= 0;
	end
 else if(read_enable &&(word_address ==2))
	begin
	   ButtonData[2] <= 0;
	  DataValid[2]  <= 0;
	end
 else if(press_button_both)
   begin
     ButtonData[2] <= 32'b1;  
     DataValid[2]  <= 1;
   end
 else if ((fake_nMode == 0) && (state_nMode == UP_nMode))
   begin
     ButtonData[0] <= 32'b1;
     DataValid[0]  <= 1;
   end
 else if ((fake_nTrip== 0) && (state_nTrip == UP_nTrip))
   begin
     ButtonData[1] <= 32'b1;
     DataValid[1]  <= 1;
   end

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
  assign Status = { 29'd0, DataValid};

  //write 


  //read
always_comb
  if ( ! read_enable )
    // (output of zero when not enabled for read is not necessary
    //  but may help with debugging)
    HRDATA = '0;
  else
    case (word_address)
      0 : HRDATA = ButtonData[0];
      1 : HRDATA = ButtonData[1];
      2 : HRDATA = ButtonData[2];
      3 : HRDATA = Status ;
      // unused address - returns zero
      default : HRDATA = '0;
    endcase

//Transfer Response
assign HREADYOUT = '1; //Single cycle Write & Read. Zero Wait state operations

endmodule

