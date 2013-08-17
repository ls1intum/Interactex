#include <Wire.h>

#define MAG_ADDRESS            (0x3C >> 1)
#define ACC_ADDRESS_SA0_A_LOW  (0x30 >> 1)
#define LSM303DLM_OUT_Y_H_M      0x07
#define LSM303_OUT_X_L_A         0x28
#define LSM303_CTRL_REG1_A       0x20

void readAcc() {
  Wire.beginTransmission(ACC_ADDRESS_SA0_A_LOW);
  Wire.write(LSM303_OUT_X_L_A | (1 << 7)); //168
  Wire.endTransmission();
  Wire.requestFrom((byte)ACC_ADDRESS_SA0_A_LOW, (byte)6);

int av = Wire.available();
Serial.println(av);

  unsigned int millis_start = millis();

  byte xla = Wire.read();
  byte xha = Wire.read();
  byte yla = Wire.read();
  byte yha = Wire.read();
  byte zla = Wire.read();
  byte zha = Wire.read();

  int x = ((int16_t)(xha << 8 | xla)) >> 4;
  int y = ((int16_t)(yha << 8 | yla)) >> 4;
  int z = ((int16_t)(zha << 8 | zla)) >> 4;
  
  Serial.print("A ");
  Serial.print("X: ");
  Serial.print((int)x);
  Serial.print(" Y: ");
  Serial.print((int)y);
  Serial.print(" Z: ");
  Serial.println((int)z);
}

void setup() {
  Serial.begin(9600);
  
  Serial.print(" first: ");
  Serial.print(ACC_ADDRESS_SA0_A_LOW);//addr
  Serial.print(" ");
  Serial.print(LSM303_CTRL_REG1_A);//reg
  Serial.print(" ");
  Serial.println(0x27);//value
  
  Serial.print(" addr: ");
  Serial.print(ACC_ADDRESS_SA0_A_LOW);
  Serial.print(" ");
  Serial.println(LSM303_OUT_X_L_A | (1 << 7));
  
  
  Wire.begin();
  
  Wire.beginTransmission(ACC_ADDRESS_SA0_A_LOW);
  Wire.write(LSM303_CTRL_REG1_A);
  Wire.write(0x27);
  Wire.endTransmission();
  
  Serial.println("finished");
}

void loop() {

readAcc();
  
  delay(300);
}
