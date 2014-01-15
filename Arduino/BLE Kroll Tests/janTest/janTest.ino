#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
long interval = 1000;

void setup()
{
  // set the data rate for the SoftwareSerial port
  bleShield.begin(19200);
  
  Serial.begin(19200);
}

void loop() // run over and over
{

  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;

//hello world! in hex  68 65 6c 6c 6f 20 77 6f 72 6c 64 21
    bleShield.write(0x68);
    bleShield.write(0x65);
    bleShield.write(0x6c);
    bleShield.write(0x6c);
    bleShield.write(0x6f);
    bleShield.write(0x20);
    bleShield.write(0x77);
    bleShield.write(0x6f);
    bleShield.write(0x72);
    bleShield.write(0x6c);
    bleShield.write(0x64);
    bleShield.write(0x21);
    //carriage return
    bleShield.write(0x0d);
    bleShield.write(0x0a);
  }

  if (bleShield.available()) {
    Serial.write(bleShield.read());
  }
}
