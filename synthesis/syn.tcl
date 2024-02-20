analyze -format sv  "../behavioural/ahb_button.sv   ../behavioural/ahb_sensor.sv   ../behavioural/ahb_rom.sv ../behavioural/ahb_ram.sv ../behavioural/arm_soc.sv ../behavioural/ahb_out_led.sv   ../behavioural/computer.sv  ../behavioural/comp_core.sv  ../behavioural/ahb_interconnect.sv  ../behavioural/CORTEXM0DS.sv ../behavioural/cortexm0ds_logic.sv " 

    elaborate computer


    #set_dont_touch [get_cells RESET_SYNC_FF*]
    #set_dont_touch [get_cells RESET_SYNC_DFC1_1]
    #set_dont_touch [get_cells RESET_SYNC_DFC1_2]
    set_dont_touch PAD_Test
    set_dont_touch PAD_SDI
    set_dont_touch PAD_SDO
    set_dont_touch PAD_ScanEnable

    create_clock -name master_clock  -period 30517.6 [get_ports Clock]
  
   set_clock_latency 5.5 [get_clocks master_clock]
   set_clock_transition 0.5 [get_clocks master_clock]
   set_clock_uncertainty 1.0 [get_clocks master_clock]
   
   set_output_delay 15.0 -max -network_latency_included -clock master_clock  [all_outputs]
   set_output_delay 0.1 -min -network_latency_included -clock master_clock  [all_outputs]
   set_input_delay 10.0 -max -network_latency_included -clock master_clock  [remove_from_collection   [all_inputs] [get_ports Clock] ]
   set_input_delay 5.0 -min -network_latency_included -clock master_clock  [remove_from_collection   [all_inputs] [get_ports Clock] ]
   
   
   set_load 1.0 -max [all_outputs]
   set_load 0.01 -min [all_outputs]

   set_driving_cell -max -library tpz018nvtc -lib_cell PDO24CDG -pin PAD [all_inputs]
   set_driving_cell -min -library tpz018nvtc -lib_cell PDO02CDG  -pin PAD [all_inputs]
   
   set_false_path -from [get_ports nReset]
   set_fix_hold  master_clock
   set_max_area 0
   

   compile

     
    set_dft_signal -view existing_dft -type ScanClock   -port Clock  -timing {45 60}
    set_dft_signal -view existing_dft -type Reset       -port nReset -active_state 0

    set_dft_signal -view spec         -type TestMode    -port Test   -active_state 1
    set_dft_signal -view spec         -type ScanEnable  -port ScanEnable   -active_state 1
    set_dft_signal -view spec         -type ScanDataIn  -port SDI 
    set_dft_signal -view spec         -type ScanDataOut -port SDO 

    create_test_protocol

    dft_drc

    set_dft_configuration -fix_reset enable
    set_autofix_configuration -type reset -method mux -control Test -test_data nReset
    #set_autofix_configuration -type reset -method gate -control Test

    set_dft_configuration -fix_set enable
    set_autofix_configuration -type set -method mux -control Test -test_data nReset
    #set_autofix_configuration -type set -method gate -control Test

    set_scan_configuration -chain_count 1

    preview_dft
   


    insert_dft

    compile -map_effort high -incremental_mapping -scan
    set_fix_hold  master_clock
    compile -map_effort high -incremental_mapping
    #compile 

    
    report_area > synth_area.rpt
    report_power > synth_power.rpt
    report_timing > synth_timing.rpt
    change_names -rules verilog -hierarchy -verbose

    write -f verilog -hierarchy -output "../gate_level/computer.v"

    write_sdc ../constraints/computer.sdc
    write_sdf ../gate_level/computer.sdf






    
