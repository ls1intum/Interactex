#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
unsigned long interval = 30; 

void setup()
{  
  bleShield.begin(19200);
  Serial.begin(9600);
  
  Serial.println("Starting");
}

void loop() // run over and over
{
  while (bleShield.available()) {
    Serial.print(bleShield.read());
    Serial.print(" ");
  }

}
