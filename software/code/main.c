#define __MAIN_C__

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// Define the raw base address values for the i/o devices


#define AHB_SENSOR_BASE          0x40000000
//SENSOR_REGS[0] count_nFork
//SENSOR_REGS[1] count_average_nFork
//SENSOR_REGS[2] count_average_nCrank
//SENSOR_REGS[3] count_time
//SENSOR_REGS[4] states


#define AHB_BUTTON_BASE          0x50000000

//BUTTON_REGs[0] press_nMode
//BUTTON_REGs[1] press_nTrip
//BUTTON_REGs[2] press_button_both
//BUTTON_REGs[3] states

#define AHB_LED_BASE             0x60000000
//LED_REGS[0] DataOut
//nDigit,DP,SegG,SegF,SegE,SegD,SegC,SegB,SegA}={4'b0111,DataOut[8:0]};

//#define AHB_OPORT_BASE           0x70000000
//OPORT_REGS[0] oPort

volatile uint32_t* SENSOR_REGS = (volatile uint32_t*) AHB_SENSOR_BASE;
volatile uint32_t* BUTTON_REGS = (volatile uint32_t*) AHB_BUTTON_BASE;
volatile uint32_t* LED_REGS = (volatile uint32_t*) AHB_LED_BASE;
//volatile uint32_t* OPORT_REGS = (volatile uint32_t*) AHB_OPORT_BASE;


#include <stdint.h>

//////////////////////////////////////////////////////////////////
// Functions provided to access i/o devices
//////////////////////////////////////////////////////////////////


////////////////////////////////



uint32_t dp_location;  //record the location of the dp
uint32_t nMode_normal_times;  // record the under the normal condition how many times the mode is pressed 
//uint32_t nTrip_times;         // record the whether the nTrip is pressed 
uint32_t nMode_wheel_times;   // record under the the wheel size  how many times the Mode button is pressed 
//uint32_t nTrip_wheel_times;   // record under the the wheel size how many times the Trip button is pressed 
bool singal_wheel;           // the singal means in the wheelsize mode 
uint32_t wheel_size ;         //the wheelsize
uint32_t bit_wheel_size;
uint32_t ten_wheel_size;
uint32_t hundrend_wheel_size;
/////////////useless OPORT which just for testing/////////////////
/*void write_out(uint32_t value) {

  OPORT_REGS[0] = value;

}

uint32_t read_out(void) {

  return OPORT_REGS[0];

}*/
/////////////////////////SENSOR REGSITERS MODULE/////////////////

uint32_t read_SENSOR(int addr) {

  return SENSOR_REGS[addr];

}



////////////////////BUTTON_REGSITERS MODULE////////////////////////////////
uint32_t read_BUTTON(int addr) {

  return BUTTON_REGS[addr];

}



/////////////////////////CALCULATE MODULE///////////////////////
uint32_t distance(float count_nfork,float circumference) { //the unit of circumference is mm
  float route;
  int int_route;
  route = count_nfork * circumference /1000000 ;

  if(route <= 10){
    route *=100;
    dp_location = 2; //
  }else if(route <= 100){
    route *=10;
    dp_location = 1;
  }else {
    dp_location = 0;
  }

  int_route = (int)route;
  //printf("int_route = %d\n",int_route);
  return int_route;
}

uint32_t timer (int count_time) { //the unit of time is second
  uint32_t time_h;
  uint32_t time_m;
  uint32_t time;
  //write_out(count_time);
  time_h = (count_time)/(3600*32768);
  time_m = (count_time-time_h*3600*32768)/(60*32768);
  //write_out(time_h);
  //write_out(time_m);
  if(time_h >=10){
    time = time_h *10 + time_m/10;
    dp_location = 1;
  }else if(time_h <10) {
    time = time_h*100 + time_m;
    dp_location = 2;
  }
  //printf("time = %d\n",time);
  return(time);
}

uint32_t cadence (int count_average_nCrank) { //the unit of time is times of rotate/m

  int rpm;
  if(count_average_nCrank == 0){
  rpm = 0;
  }else{
  rpm = (60*32768/count_average_nCrank);
  }
  dp_location = 0;
  //printf("cadence_rpm = %d\n",rpm);
  return(rpm);
}


uint32_t speed (float count_average_nFork, float circumference) { //the unit of time is km/h
  float speed_value;
  int int_speed;
  
  //write_out(count_average_nFork);
  if(count_average_nFork == 0){
     speed_value = 0;
  }else {
     speed_value = ((circumference*32768*3.6)/(1000*count_average_nFork));
  }

  //write_out(speed_value);
  //printf("speed_value212 = %f\n",speed_value);
  if(speed_value <= 10){
    speed_value *=100;
    dp_location = 2; //
  }else if(speed_value <= 100){
    speed_value *=10;
    dp_location = 1;
  }else {
    dp_location = 0;
  }

  int_speed = (int)speed_value;
  //printf("speed = %d\n",int_speed);
  return int_speed;
}



/////////////////////////LED MODULE///////////////////////////
uint32_t seg_code(int value){

  //printf("value = %d\n",value);
  uint32_t display_value;
  switch(value){
									   //i ogfe dcba
  case 0: display_value = 0x0000003f  ;break; //0000_0000_0000_0000_0000_111 0_0011_1111

  case 1: display_value = 0x00000006  ;break; //0000_0000_0000_0000_0000_111 0_0000_0110

  case 2: display_value = 0x0000005b  ;break; //0000_0000_0000_0000_0000_111 0_0101_1011

  case 3: display_value = 0x0000004f  ;break; //0000_0000_0000_0000_0000_111 0_0100_1111

  case 4: display_value = 0x00000066  ;break; //0000_0000_0000_0000_0000_111 0_0110_0110

  case 5: display_value = 0x0000006d  ;break; //0000_0000_0000_0000_0000_111 0_0110_1101

  case 6: display_value = 0x0000007d  ;break; //0000_0000_0000_0000_0000_111 0_0111_1101

  case 7: display_value = 0x00000007  ;break; //0000_0000_0000_0000_0000_111 0_0000_0111

  case 8: display_value = 0x0000007f   ;break; //0000_0000_0000_0000_0000_111 0_0111_1111 
  
  case 9: display_value = 0x0000006f  ;break; //0000_0000_0000_0000_0000_111 0_0110_1111
  //default: printf("there is an error in digital 1");break;
  default: display_value = 0x00000000 ;break;
 }
 //printf("display_value = %x\n",display_value);
 return display_value;
}



uint32_t seg_mod(int mode){


  uint32_t display_value; 
  //write_out(wheel_size);
  switch(mode){
									   //i ogfe dcba
  case 0: display_value = 0x0000005e  ;break; //0000_0000_0000_0000_0000_011 1_0101_1110  distance 

  case 1: display_value = 0x00000078  ;break; //0000_0000_0000_0000_0000_011 1_0111_1000  trip

  case 2: display_value = 0x0000000c  ;break; //0000_0000_0000_0000_0000_011 1_0000_1100  speed

  case 3: display_value = 0x00000058  ;break; //0000_0000_0000_0000_0000_011 1_0101_1000  cadence
  
  case 4: display_value = 0x00000039  ;break; //0000_0000_0000_0000_0000_011 1_0011_1001  wheel size

  //default: printf("there is an error in digital 4");break;
  default: display_value = 0x00000000 ;break;
 }
 return display_value;
}

uint32_t write_led(uint32_t value1,uint32_t value2,uint32_t value3,uint32_t value4) {
  uint32_t value_total;

  //printf("value1 = %x ,value2 =%x,value3 = %x,value4 = %x \n",value1,value2,value3,value4);
  value2 = value2 << 8 ;
  value3 = value3 << 16 ;
  value4 = value4 << 24 ;
  value_total = value1 + value2 + value3 + value4;
  //printf("value_total %x \n",value_total); 
  return value_total;
}

void seg_decode(int mode,int value,uint32_t dp){

  uint32_t bit_value ;
  uint32_t ten_value ;
  uint32_t hundrend_value;
  //uint32_t mode_value;

  //uint32_t value_all;

  uint32_t add_value;

  uint32_t display_value;
  //write_out(mode);
  bit_value = value %10;        //fetch bit
  ten_value = value %100 /10;   //fetch ten
  hundrend_value = value /100;  // fetch hundrend
  //printf("bit_value = %d ,ten_value = %d ,hundrend_value = %d\n",bit_value,ten_value,hundrend_value);
  //printf("seg_decode_dp = %x\n",dp);
  if(dp == 1){
    add_value = 0x00000080 <<8;
  }else if(dp ==2){
    add_value = 0x00000080 <<16;
  }else 
    add_value = 0x00000000;
  //printf("seg_decode_add_value = %x\n",add_value);

  
  // switch(mode){   //为什么不能直接变成 display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break;

  // //odometer pattern
  // case 0: display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break;

  // case 1: display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break;
  
  // case 2: display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break;

  // case 3: display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break;

  // case 4: display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;break; 

  // default : display_value = 0x00000000; break;

  // }
  display_value = write_led(seg_code(bit_value),seg_code(ten_value),seg_code(hundrend_value),seg_mod(mode)) + add_value;
  //return display_value;
  LED_REGS[0] = display_value;
}
// clear the value of register 
void clear_all_register(void){
  SENSOR_REGS[0] = 0;
  //SENSOR_REGS[1] = 0;
  //SENSOR_REGS[2] = 0;
  SENSOR_REGS[3] = 0;
  if(nMode_normal_times == 0){
  LED_REGS[0] = 0x5ebf3f3f;
  }else if(nMode_normal_times == 1){
  LED_REGS[0] = 0x78bf3f3f;
  }
}


///////////////////////////////////

bool check_sensor(int addr) {

  int status, sensor_ready;
  
  status = SENSOR_REGS[4];
  //write_out(status);
  // use the addr value to select one bit of the status register
  sensor_ready = (status >> addr) & 1;
  //write_out(sensor_ready);
  return (sensor_ready == 1);
}

bool check_button(int addr) {

  int status, button_ready;
  
  status = BUTTON_REGS[3];
  
  // use the addr value to select one bit of the status register
  button_ready = (status >> addr) & 1;
  
  return (button_ready == 1);
}

/////////////////////////////////////////////wait_for_button//////////




void wait_for_any_BUTTON_data(void){
  bool button_Mode, button_nTrip,button_both;
  
    button_both = false;
    button_nTrip = false;
    button_Mode = false;
    uint32_t wheel_size_tmp;
    // button_Mode = BUTTON_REG[0];
    // button_nTrip =  BUTTON_REG[1];
    // button_both = BUTTON_REG[2];
    if(check_button(2)){
    button_both = read_BUTTON(2);
    }
    else if(check_button(1)){
    button_nTrip = read_BUTTON(1);    
    }
    else if(check_button(0)){
    button_Mode = read_BUTTON(0);    
    }
    else {
    button_both = false;
    button_nTrip = false;
    button_Mode = false;
    }



    //write_out(button_both);
  
  //write_out(button_Mode);
  if(singal_wheel == 0){
    if(button_Mode){
      nMode_normal_times += 1;
      if(nMode_normal_times == 4){
      nMode_normal_times = 0;
      }
    }
    if(button_nTrip){
      clear_all_register();
    }
  }


  if(button_both){
    singal_wheel = 1;
    //wheel_size = 0;
    //bit_wheel_size = 0;
    //ten_wheel_size = 0;
    //hundrend_wheel_size = 0;
  }
  
  if(singal_wheel){
    if(button_Mode){
      nMode_wheel_times += 1; 
    }
    switch(nMode_wheel_times){
    
    case 0: if(button_nTrip){
	      
              bit_wheel_size = bit_wheel_size + 1;
              if(bit_wheel_size>9){
                bit_wheel_size = 0;
              }
            }
            break;

    case 1: if(button_nTrip){
              //write_out(0x55555555);
              ten_wheel_size = ten_wheel_size + 1;
              if(ten_wheel_size >9){
                ten_wheel_size = 0;
              }
            }
            break;

    case 2:if(button_nTrip){
              hundrend_wheel_size = hundrend_wheel_size + 1;
              if(hundrend_wheel_size >=3){
                hundrend_wheel_size = 0;
              }
            }
            break;

    case 3: singal_wheel = 0;nMode_wheel_times = 0;nMode_normal_times = 0;break;

    default:;break;
    }
    wheel_size_tmp = (bit_wheel_size + ten_wheel_size*10 + hundrend_wheel_size *100);
    wheel_size = wheel_size_tmp *10;
    //write_out(wheel_size_tmp);
    dp_location = 0;
    seg_decode(4,wheel_size_tmp,dp_location);
    //write_out(0x000000002);
  }
  

}


/////////////////////////other function///////////////////////////////
void delay(void){

 for(int i=0;i<20000;i++);
 }


//////////////////////////////////////////////////////////////////
// Main Function
//////////////////////////////////////////////////////////////////


int main(void){
  uint32_t route;
  uint32_t fast;
  uint32_t rpm;
  uint32_t time;
  wheel_size = 2136; 
  while(1){
    wait_for_any_BUTTON_data();
    //write_out(wheel_size);
    if(singal_wheel == 0){
    //write_out(nMode_normal_times);
    switch(nMode_normal_times){
      case 0:
	    //write_out(0x55555555);
	    if(check_sensor(0)){
            route = distance(read_SENSOR(0),wheel_size);
            seg_decode(0,route,dp_location);
	    }
            break;
	
      case 1:
	    //write_out(0x44444444);	
	    if(check_sensor(3)){
            time = timer(read_SENSOR(3));
            seg_decode(1,time,dp_location);
	    }
	    //write_out(time);	
	    break;
      case 2:
	    if(check_sensor(1)){
            fast = speed(read_SENSOR(1),wheel_size);
            seg_decode(2,fast,dp_location);	    
	    }
	    break;
            //write_out(0x000000003);     
          
      case 3:
            if(check_sensor(2)){
            rpm = cadence(read_SENSOR(2));
            seg_decode(3,rpm,dp_location);
	    }
	    break;
	    //write_out(0x000000004);	
      default: ;break;
    }
   }
  }
}



