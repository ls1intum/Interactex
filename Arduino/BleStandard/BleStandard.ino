#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
long interval = 1000; 

void setup()
{
  // set the data rate for the SoftwareSerial port
  bleShield.begin(14400);
  Serial.begin(9600);
  
    Serial.println("Starting");
  
}

void loop() // run over and over
{
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;   
    /*
    bleShield.write(1);
    bleShield.write(2);
    bleShield.write(3);
    bleShield.write(4);*/
    
    bleShield.write(0x4D);
    bleShield.write(0x2A);
    bleShield.write(0x10);
    bleShield.write(0x20);
  }

  if (bleShield.available()) {
    int val = bleShield.read();
    Serial.println(val,HEX);
  }
}
