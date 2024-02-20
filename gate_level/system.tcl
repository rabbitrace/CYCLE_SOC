
# system.tcl

database -open waves.shm -default

simvision {

  source /opt/cad/bim/fcde/tcl/routines.tcl
  source /opt/cad/bim/fcde/tcl/read_fig.tcl

  ecsWaves  {
    system.Clock
    system.nReset
    system.nMode
    system.nTrip
    system.nFork
    system.nCrank
    system.SegA
    system.SegB
    system.SegC
    system.SegD
    system.SegE
    system.SegF
    system.SegG
    system.DP
    system.nDigit
    system.mode_index
    } "Waves for Any Cycle Computer Design"
 # =========================================================================
 # Register Window

  # Open new register window
   window new RegisterWindow -name "Registers for LED output"

   window geometry "Registers for LED output" 700x400+0+500

   register using "Registers for LED output" 

    register add system.SegA
    register add system.SegB
    register add system.SegC
    register add system.SegD
    register add system.SegE
    register add system.SegF
    register add system.SegG


# Add signal values (specified location and format)
     #register addtype -type text -x0 200 -y0 20 -text {tl} 

#----------------Seg A -------------------------------------------

    register addtype -type signalvalue -x0 520 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 480 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 490 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 500 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 510 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 530 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 540 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 550 -y0 30 -radix %b\
      system.SegA
    register addtype -type signalvalue -x0 560 -y0 30 -radix %b\
      system.SegA

#----------------Seg B -------------------------------------------

    register addtype -type signalvalue -x0 570 -y0 60 -radix %b\
      system.SegB
   register addtype -type signalvalue -x0 570 -y0 50 -radix %b\
      system.SegB
   register addtype -type signalvalue -x0 570 -y0 40 -radix %b\
      system.SegB
   register addtype -type signalvalue -x0 570 -y0 70 -radix %b\
      system.SegB
   register addtype -type signalvalue -x0 570 -y0 80 -radix %b\
      system.SegB


#----------------Seg C -------------------------------------------




    register addtype -type signalvalue -x0 570 -y0 120 -radix %b\
      system.SegC
    register addtype -type signalvalue -x0 570 -y0 110 -radix %b\
      system.SegC
    register addtype -type signalvalue -x0 570 -y0 100 -radix %b\
      system.SegC
    register addtype -type signalvalue -x0 570 -y0 130 -radix %b\
      system.SegC
    register addtype -type signalvalue -x0 570 -y0 140 -radix %b\
      system.SegC


#----------------Seg D -------------------------------------------

    register addtype -type signalvalue -x0 520 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 480 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 490 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 500 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 510 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 530 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 540 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 550 -y0 150 -radix %b\
      system.SegD
    register addtype -type signalvalue -x0 560 -y0 150 -radix %b\
      system.SegD


#----------------Seg E -------------------------------------------

    register addtype -type signalvalue -x0 470 -y0 120 -radix %b\
      system.SegE
    register addtype -type signalvalue -x0 470 -y0 110 -radix %b\
      system.SegE
    register addtype -type signalvalue -x0 470 -y0 100 -radix %b\
      system.SegE
    register addtype -type signalvalue -x0 470 -y0 130 -radix %b\
      system.SegE
    register addtype -type signalvalue -x0 470 -y0 140 -radix %b\
      system.SegE

#----------------Seg F -------------------------------------------



    register addtype -type signalvalue -x0 470 -y0 60 -radix %b\
      system.SegF
    register addtype -type signalvalue -x0 470 -y0 50 -radix %b\
      system.SegF
    register addtype -type signalvalue -x0 470 -y0 40 -radix %b\
      system.SegF
    register addtype -type signalvalue -x0 470 -y0 70 -radix %b\
      system.SegF
    register addtype -type signalvalue -x0 470 -y0 80 -radix %b\
      system.SegF

#----------------Seg G -------------------------------------------




    register addtype -type signalvalue -x0 520 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 480 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 490 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 500 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 510 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 530 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 540 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 550 -y0 90 -radix %b\
      system.SegG
    register addtype -type signalvalue -x0 560 -y0 90 -radix %b\
      system.SegG

  # Add shapes and text to regs window
# =========================================================================
# Probe
     
  
    #register addtype -type rectangle -x0 100 -y0 20 -x1 300 -y1 105 \
      #-outline green
    register addtype -type text -x0 500 -y0 30 -text()
    register addtype -type text -x0 550 -y0 60 -text()
    register addtype -type text -x0 550 -y0 120 -text()
    register addtype -type text -x0 500 -y0 150 -text()
    register addtype -type text -x0 450 -y0 120 -text()
    register addtype -type text -x0 450 -y0 60 -text()
    register addtype -type text -x0 500 -y0 90 -text()
  # Any signals included in register window but not in waveform window
  # should be probed
}
# =========================================================================
