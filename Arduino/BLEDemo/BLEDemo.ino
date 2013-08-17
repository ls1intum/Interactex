#include "SoftwareSerial.h"

unsigned long currentMillis;        // store the current value from millis()
unsigned long previousMillis;       // for comparison with currentMillis
long interval = 100; 


boolean shouldSend;
byte nextVal = 100;

SoftwareSerial ss(2,3);

void setup() 
{
  Serial.begin(9600);
  ss.begin(19200);
  
  shouldSend = 0;
  
}

void loop() 
{
  
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis; 
    
  byte pin, analogPin;

  while(ss.available()){
    byte val = ss.read();
    
      //Serial.println(val);
      
    if(val != nextVal){
      int valInt = val;
      Serial.print(valInt);
      //Serial.print(valInt, BIN);
      Serial.print( " next is: ");
      int nextValInt = nextVal;
            Serial.println(nextValInt);
//      Serial.println(nextValInt, BIN);
    }
   
    
    nextVal = val + 1;
    if(nextVal == 116){//the iOS side sends [100 ... 116]
      nextVal = 100;
    }
  }
  
   
    
    for(int j = 100 ; j < 116 ; j++){
      ss.write(j);
    }
  }
  
//delay(100);
}
