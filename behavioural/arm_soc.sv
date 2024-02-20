// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton

module arm_soc(

  input HCLK, HRESETn,
  output SegA,SegB,SegC,SegD,SegE,SegF,SegG,DP,
  output [3:0]nDigit,  
  output LOCKUP,
  input  nCrank,
  input  nFork,
  input  nMode,
  input  nTrip
/*  input [31:0] iPort, 

  

*/
);
 
timeunit 1ns;
timeprecision 100ps;

  // Global & Master AHB Signals
  wire [31:0] HADDR, HWDATA, HRDATA;
  wire [1:0] HTRANS;
  wire [2:0] HSIZE, HBURST;
  wire [3:0] HPROT;
  wire HWRITE, HMASTLOCK, HRESP, HREADY;

  // Per-Slave AHB Signals
  wire HSEL_ROM, HSEL_RAM,HSEL_LED,HSEL_BUTTON,HSEL_SENSOR,HSEL_OPORT;
  wire [31:0] HRDATA_ROM, HRDATA_RAM,HRDATA_LED,HRDATA_BUTTON,HRDATA_SENSOR,HRDATA_OPORT;
  wire HREADYOUT_ROM, HREADYOUT_RAM,HREADYOUT_LED,HREADYOUT_BUTTON,HREADYOUT_SENSOR,HREADYOUT_OPORT;

  // Non-AHB M0 Signals
  wire TXEV, RXEV, SLEEPING, SYSRESETREQ, NMI;
  wire [15:0] IRQ;


  // Set this to zero because simple slaves do not generate errors
  assign HRESP = '0;

  // Set all interrupt and event inputs to zero (unused in this design) 
  assign NMI = '0;
  assign IRQ = {16'b0000_0000_0000_0000};
  assign RXEV = '0;

  // Coretex M0 DesignStart is AHB Master
  CORTEXM0DS m0_1 (

    // AHB Signals
    .HCLK, .HRESETn,
    .HADDR, .HBURST, .HMASTLOCK, .HPROT, .HSIZE, .HTRANS, .HWDATA, .HWRITE,
    .HRDATA, .HREADY, .HRESP,                                   

    // Non-AHB Signals
    .NMI, .IRQ, .TXEV, .RXEV, .LOCKUP, .SYSRESETREQ, .SLEEPING

  );


  // AHB interconnect including address decoder, register and multiplexer
/*  ahb_interconnect interconnect_1 (

    .HCLK, .HRESETn, .HADDR, .HRDATA, .HREADY,

    .HSEL_SIGNALS({HSEL_OPORT,HSEL_LED,HSEL_BUTTON,HSEL_SENSOR,HSEL_RAM,HSEL_ROM}),
    .HRDATA_SIGNALS({HRDATA_OPORT,HRDATA_LED,HRDATA_BUTTON,HRDATA_SENSOR,HRDATA_RAM,HRDATA_ROM}),
    .HREADYOUT_SIGNALS({HREADYOUT_OPORT,HREADYOUT_LED,HREADYOUT_BUTTON,HREADYOUT_SENSOR,HREADYOUT_RAM,HREADYOUT_ROM})

  );*/

    ahb_interconnect interconnect_1 (

    .HCLK, .HRESETn, .HADDR, .HRDATA, .HREADY,

    .HSEL_SIGNALS({HSEL_LED,HSEL_BUTTON,HSEL_SENSOR,HSEL_RAM,HSEL_ROM}),
    .HRDATA_SIGNALS({HRDATA_LED,HRDATA_BUTTON,HRDATA_SENSOR,HRDATA_RAM,HRDATA_ROM}),
    .HREADYOUT_SIGNALS({HREADYOUT_LED,HREADYOUT_BUTTON,HREADYOUT_SENSOR,HREADYOUT_RAM,HREADYOUT_ROM})

  );


  // AHBLite Slaves
        
 ahb_rom rom_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_ROM),
    .HRDATA(HRDATA_ROM), .HREADYOUT(HREADYOUT_ROM)

  );

  ahb_ram ram_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_RAM),
    .HRDATA(HRDATA_RAM), .HREADYOUT(HREADYOUT_RAM)

  );

  ahb_out_led led_1(
    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_LED),
    .HRDATA(HRDATA_LED), .HREADYOUT(HREADYOUT_LED),
    .SegA(SegA),.SegB(SegB),.SegC(SegC),.SegD(SegD),.SegE(SegE),.SegF(SegF),.SegG(SegG),.DP(DP),.nDigit(nDigit)

);


  ahb_sensor sensor1(
    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_SENSOR),
    .HRDATA(HRDATA_SENSOR), .HREADYOUT(HREADYOUT_SENSOR),
    .nCrank(nCrank), .nFork(nFork)
);


ahb_button button1(
    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_BUTTON),
    .HRDATA(HRDATA_BUTTON), .HREADYOUT(HREADYOUT_BUTTON),
    .nMode(nMode),.nTrip(nTrip)
);


/*  ahb_output_port out_1 (

    .HCLK, .HRESETn, .HADDR, .HWDATA, .HSIZE, .HTRANS, .HWRITE, .HREADY,
    .HSEL(HSEL_OPORT),
    .HRDATA(HRDATA_OPORT), .HREADYOUT(HREADYOUT_OPORT),

    .oPort(oPort)

  );*/
endmodule
