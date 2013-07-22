#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
long interval = 50; 
byte counter = 0;

void setup()
{
  pinMode(4,INPUT);
  
  // set the data rate for the SoftwareSerial port
  bleShield.begin(19200);
  //bleShield.begin(14400);
  Serial.begin(9600);
  
    Serial.println("Starting");
    bleShield.flush();
    //bleShield.write(121);
}

void loop() // run over and over
{
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;  
   
   for(int i =0;i<4;i++){
    bleShield.write(0x12);
    bleShield.write(0x2A);
    bleShield.write(0x10);
    bleShield.write(0x20);
   }
  }
  
/*
int val = digitalRead(4);
if(!val){
  Serial.println("button pressed");
    
        }*/

  while (bleShield.available()) {
    Serial.println(bleShield.read());
  }
}
