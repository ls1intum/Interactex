/*
The sensor outputs provided by the library are the raw 16-bit values
obtained by concatenating the 8-bit high and low accelerometer and
magnetometer data registers. They can be converted to units of g and
gauss using the conversion factors specified in the datasheet for your
particular device and full scale setting (gain).

Example: An LSM303D gives a magnetometer X axis reading of 1982 with
its default full scale setting of +/- 4 gauss. The M_GN specification
in the LSM303D datasheet (page 10) states a conversion factor of 0.160
mgauss/LSB (least significant bit) at this FS setting, so the raw
reading of -1982 corresponds to 1982 * 0.160 = 317.1 mgauss =
0.3171 gauss.

In the LSM303DLHC, LSM303DLM, and LSM303DLH, the acceleration data
registers actually contain a left-aligned 12-bit number, so the lowest
4 bits are always 0, and the values should be shifted right by 4 bits
(divided by 16) to be consistent with the conversion factors specified
in the datasheets.

Example: An LSM303DLH gives an accelerometer Z axis reading of -16144
with its default full scale setting of +/- 2 g. Dropping the lowest 4
bits gives a 12-bit raw value of -1009. The LA_So specification in the
LSM303DLH datasheet (page 11) states a conversion factor of 1 mg/digit
at this FS setting, so the value of -1009 corresponds to -1009 * 1 =
1009 mg = 1.009 g.
*/

#include <Wire.h>

#define OUT_X_L_A         0x28

#define accAddress 40

char report[80];
int x,y,z;

void setup()
{
  Serial.begin(9600);
  Wire.begin();
  
  Wire.beginTransmission(24);
    
  Wire.write(0x23);
  Wire.write(0x00);
  
  Wire.endTransmission();
  
  Wire.beginTransmission(24);
    
  Wire.write(0x20);
  Wire.write(0x27);
  
  Wire.endTransmission();
}

void readAcc(void)
{
  Wire.beginTransmission(24);
  // assert the MSB of the address to get the accelerometer
  // to do slave-transmit subaddress updating.
  Wire.write(OUT_X_L_A | (1 << 7));
  //Wire.write(40);
  Wire.endTransmission();
  Wire.requestFrom(24, 6);

  unsigned int millis_start = millis();
  
  if (Wire.available() == 6) {

    byte xla = Wire.read();
    byte xha = Wire.read();
    byte yla = Wire.read();
    byte yha = Wire.read();
    byte zla = Wire.read();
    byte zha = Wire.read();
  
    x = (int16_t)(xha << 8 | xla);
    y = (int16_t)(yha << 8 | yla);
    z = (int16_t)(zha << 8 | zla);
    
    snprintf(report, sizeof(report), "A: %6d %6d %6d",
      x, y, z);
    Serial.println(report);
  }
  
}

void loop() {
  readAcc();

  delay(100);
}
