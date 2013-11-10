#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
unsigned long interval = 30; 
int counter = 0;
void setup()
{  
  bleShield.begin(19200);
  //Serial.begin(9600);

}

void loop() // run over and over
{
  char buf[16];
  
  for(int i = 0; i < 16 ; i++){
    buf[i] = 0;
  }
  
  while (bleShield.available()) {
    
    char myByte = bleShield.read();
    buf[counter++] = myByte;
    
    if(counter >= 16){
       counter = 0;
     }
  }
  
  delay(200);
  
  for(int i = 0 ; i < 16 ; i++){
    bleShield.write(buf[i]);
  }
}
