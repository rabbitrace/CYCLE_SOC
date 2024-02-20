module computer (
  input nMode,
  input ScanEnable,
  input nReset,
  output [3:0] nDigit,
  input SDI,
  input Test,
  output SegF,
  input nCrank,
  output DP,
  output SegC,
  output SegE,
  output SegD,
  output SegA,
  input nTrip,
  output SDO,
  output SegB,
  input Clock,
  input nFork,
  output SegG
);

  wire CORE_nMode;
  wire CORE_ScanEnable;
  wire CORE_nReset;
  wire [3:0] CORE_nDigit;
  wire CORE_SDI;
  wire CORE_Test;
  wire CORE_SegF;
  wire CORE_nCrank;
  wire CORE_DP;
  wire CORE_SegC;
  wire CORE_SegE;
  wire CORE_SegD;
  wire CORE_SegA;
  wire CORE_nTrip;
  wire CORE_SDO;
  wire CORE_SegB;
  wire CORE_Clock;
  wire CORE_nFork;
  wire CORE_SegG;
  wire SYNC_MID_nReset;
  wire SYNC_IN_nReset;

  wire SYNC_IN_nMode;
  wire SYNC_MID_nMode;

  wire SYNC_IN_nTrip;
  wire SYNC_MID_nTrip;

  wire SYNC_IN_nFork;
  wire SYNC_MID_nFork;

  wire SYNC_IN_nCrank;
  wire SYNC_MID_nCrank;

   // synopsys dc_tcl_script_begin
   //   set_dont_touch [get_cells RESET_SYNC_FF*]
   // synopsys dc_tcl_script_end


    DFCNQD1BWP7T RESET_SYNC_FF1 (
      .D('1),              .Q(SYNC_MID_nReset), .CP(CORE_Clock), .CDN(SYNC_IN_nReset)
    );

    DFCNQD1BWP7T RESET_SYNC_FF2 (
       .D(SYNC_MID_nReset), .Q(CORE_nReset),    .CP(CORE_Clock), .CDN(SYNC_IN_nReset)
    );


    DFCNQD1BWP7T nMode_SYNC_FF1 (
      .D(SYNC_IN_nMode),       .Q(SYNC_MID_nMode), .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nMode_SYNC_FF2 (
       .D(SYNC_MID_nMode), .Q(CORE_nMode),    .CP(CORE_Clock), .CDN(CORE_nReset)
    );


    DFCNQD1BWP7T nTrip_SYNC_FF1 (
      .D(SYNC_IN_nTrip),       .Q(SYNC_MID_nTrip), .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nTrip_SYNC_FF2 (
       .D(SYNC_MID_nTrip), .Q(CORE_nTrip),    .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nFork_SYNC_FF1 (
      .D(SYNC_IN_nFork),       .Q(SYNC_MID_nFork), .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nFork_SYNC_FF2 (
       .D(SYNC_MID_nFork), .Q(CORE_nFork),    .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nCrank_SYNC_FF1 (
      .D(SYNC_IN_nCrank),       .Q(SYNC_MID_nCrank), .CP(CORE_Clock), .CDN(CORE_nReset)
    );

    DFCNQD1BWP7T nCrank_SYNC_FF2 (
       .D(SYNC_MID_nCrank), .Q(CORE_nCrank),    .CP(CORE_Clock), .CDN(CORE_nReset)
    );



  PDO08CDG PAD_SegE ( .PAD(SegE), .I(CORE_SegE) );
  PDO08CDG PAD_SegD ( .PAD(SegD), .I(CORE_SegD) );
  PDO08CDG PAD_SegC ( .PAD(SegC), .I(CORE_SegC) );
  PDO08CDG PAD_SegB ( .PAD(SegB), .I(CORE_SegB) );
  PDO08CDG PAD_SegA ( .PAD(SegA), .I(CORE_SegA) );
  PDIDGZ PAD_ScanEnable ( .PAD(ScanEnable), .C(CORE_ScanEnable) );
  PDIDGZ PAD_Clock ( .PAD(Clock), .C(CORE_Clock) );
  PDIDGZ PAD_nReset ( .PAD(nReset), .C(SYNC_IN_nReset) );
  PDIDGZ PAD_Test ( .PAD(Test), .C(CORE_Test) );
  PDIDGZ PAD_SDI ( .PAD(SDI), .C(CORE_SDI) );
  PDO08CDG  PAD_SDO ( .PAD(SDO), .I(CORE_SDO) );

  PDUDGZ PAD_nMode ( .PAD(nMode), .C(SYNC_IN_nMode) );
  PDUDGZ PAD_nTrip ( .PAD(nTrip), .C(SYNC_IN_nTrip) );
  PDUDGZ PAD_nFork ( .PAD(nFork), .C(SYNC_IN_nFork) );
  PDUDGZ PAD_nCrank ( .PAD(nCrank), .C(SYNC_IN_nCrank) );

  PDO08CDG  PAD_nDigit_3 ( .PAD(nDigit[3]), .I(CORE_nDigit[3]) );
  PDO08CDG  PAD_nDigit_2 ( .PAD(nDigit[2]), .I(CORE_nDigit[2]) );
  PDO08CDG  PAD_nDigit_1 ( .PAD(nDigit[1]), .I(CORE_nDigit[1]) );
  PDO08CDG  PAD_nDigit_0 ( .PAD(nDigit[0]), .I(CORE_nDigit[0]) );
  PDO08CDG  PAD_DP ( .PAD(DP), .I(CORE_DP) );
  PDO08CDG  PAD_SegG ( .PAD(SegG), .I(CORE_SegG) );
  PDO08CDG  PAD_SegF ( .PAD(SegF), .I(CORE_SegF) );

  comp_core comp_core_inst (
    .nMode(CORE_nMode),
    .nReset(CORE_nReset),
    .nDigit(CORE_nDigit),
    .SegF(CORE_SegF),
    .nCrank(CORE_nCrank),
    .DP(CORE_DP),
    .SegC(CORE_SegC),
    .SegE(CORE_SegE),
    .SegD(CORE_SegD),
    .SegA(CORE_SegA),
    .nTrip(CORE_nTrip),
    .SegB(CORE_SegB),
    .Clock(CORE_Clock),
    .nFork(CORE_nFork),
    .SegG(CORE_SegG)
  );

endmodule
