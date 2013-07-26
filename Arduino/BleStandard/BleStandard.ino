#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0;
unsigned long interval = 30; 
byte counter = 0;
byte counter2 = 0;

void setup()
{
  pinMode(4,INPUT);
  
  // set the data rate for the SoftwareSerial port
  bleShield.begin(19200);
  //bleShield.begin(14400);
  Serial.begin(9600);
  
    //Serial.println("Starting");
    //bleShield.flush();
    //bleShield.write(121);
}

void loop() // run over and over
{
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;  
   /*
    bleShield.write(counter++);
    if(counter > 256){
      counter = 0;
    }*/
  }
  
/*
int val = digitalRead(4);
if(!val){
  Serial.println("button pressed");
    
        }*/

  while (bleShield.available()) {
    Serial.print(bleShield.read());
    Serial.print(" ");
    counter++;
    if(counter == 16){
      counter = 0;
      Serial.println("");
    }
  }
  
  delay(250);
}
