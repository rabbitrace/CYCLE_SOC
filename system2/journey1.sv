// This special stimulus simulates a cycle journey with a gear change 

  // Hall-effect sensor stimulus
  //
  //  This default stimulus represents initial inactivity
  //  followed by pedalling at a constant rate for about 10 seconds 
  //  After this we go downhill - pedalling slower but travelling faster 

  initial
    begin
      Crank = 0;
      #13s
      repeat(200)
        #500ms -> trigger_crank_sensor;//100s

    end

// for simulations

initial
    begin
      Fork = 0;
      #13s
      repeat(10)
        #1000ms -> trigger_fork_sensor; //27s
      repeat(10)
        #500ms -> trigger_fork_sensor; //32s
      repeat(25)
        #200ms -> trigger_fork_sensor; //37s
      repeat(100)
        #1000ms -> trigger_fork_sensor; //137s
    end



 /* 
  initial
    begin
      Fork = 0;
      #0.6s
      repeat(10)
        #1000ms -> trigger_fork_sensor;
      #0.2s
      forever
        #500ms -> trigger_fork_sensor;
    end
  */
  // Button stimulus
  //
  //  After about 5 seconds switch to speed display 

  initial
    begin
      Mode = 0;
      mode_index = 0;
      #2s  -> press_mode_button; //2s

      #3s -> press_mode_button; //5s

      #5.5s -> press_mode_button; //10.5s
     
      #2s -> press_mode_button; //12.5s  odometer
      #10s -> press_mode_button; //27s time
      #0.5s -> press_mode_button; //27.5s speed
      #60s -> press_mode_button; //87s rapm 
      #20s -> press_mode_button; //107s odometer
      #21s -> press_mode_button; //128s time
      #0.5s -> press_mode_button; //128.5s  speed 
      #5s -> press_mode_button; //rapm
            

    end

  initial
    begin
      Trip = 0;
      #2s  -> press_trip_button;
      repeat(5)     
      #0.5s -> press_trip_button; //4.5s
      #1.5s                  //6s
      repeat(8)     
      #0.5s -> press_trip_button;//10s
      #1s			//11s
      repeat(1)     
      #0.5s -> press_trip_button;//11.5s
      #110s -> press_trip_button;//126.5
   
    end
  


  // Stimulus not changed for
  // Clock nReset and scan path signals 

  initial
    begin
      Test = 0;
      SDI = 0;
      ScanEnable = 0;
      nReset = 0;
      repeat(5)#(`clock_period) nReset = 0;     
      #(`clock_period / 4) nReset = 1;
    end

/*  initial 
    begin
      SDI = 0;
      forever #100ms SDI = ~SDI;
    end
*/
  initial
    begin
      Clock = 0;
      #`clock_period
      forever
        begin
          Clock = 1;
          #(`clock_period / 2) Clock = 0;
          #(`clock_period / 2) Clock = 0;
        end
    end



