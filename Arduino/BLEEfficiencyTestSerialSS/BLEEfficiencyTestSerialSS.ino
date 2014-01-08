
#include "SoftwareSerial.h"

unsigned long currentMillis;        // store the current value from millis()
unsigned long previousMillis;       // for comparison with currentMillis
long interval = 100; 
int count = 0;

void setup() 
{
  Serial.begin(19200);
  
  pinMode(13,OUTPUT);
  digitalWrite(13,LOW);
}

/*constantly send data and suddenly receive something, sometimes received data is not what was sent
*/

void loop() 
{
  unsigned long currentMillis = millis();

  while(Serial.available()){
    byte val = Serial.read();
    
    if(val < 'd' || val > 'r'){
      digitalWrite(13,HIGH);
    }
    
  }
  
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis; 
    
    for(int j = 100 ; j < 116 ; j++){
      Serial.write(j);
    }
  }
 
}
