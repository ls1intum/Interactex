#include <SoftwareSerial.h>

SoftwareSerial bleShield(2, 3);

long previousMillis = 0; 
int count_bytes=0;
byte maximum_ble_buff[16];

void setup()  
{
  // set the data rate for the SoftwareSerial port
  bleShield.begin(19200);
  Serial.begin(19200);
  delay(1000);  
  
  
}

void loop() // run over and over
{
  
  unsigned long currentMillis = millis();
 
  int bytes_av=0;
  
  
  if (bleShield.available())
  {
  
    
    bytes_av = bleShield.available();
    while (bleShield.available())
    {
    if (count_bytes < 16)
    {
    maximum_ble_buff[count_bytes] = bleShield.read();
    count_bytes++;
    }
    else
    {
      count_bytes=0;
      for (int i=0; i<16; i++)
      {
        Serial.write(maximum_ble_buff[i]);
      bleShield.write(maximum_ble_buff[i]);
      }
      Serial.println();
    break;
    }
    }
  }
  Serial.flush();
delay(50);
}
