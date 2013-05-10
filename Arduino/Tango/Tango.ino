#include <SoftwareSerial.h>
#include <LSM303.h>
#include <Wire.h>

SoftwareSerial bleShield(2, 3);

//variables
long previousMillis = 0;
long interval = 300; 
int recvCount = 0;
int currPin;
int currentState = 0;
int typeBLE = 1; //0 for original BLE shield, 1 for BLEbee shield

//constants
#define kStatePinModes 0
#define kStatePinValues 1

#define kMsgPinModeStarted 255
#define kMsgPinValueStarted 254

#define kNumDigitalPins 14
#define kNumAnalogPins 6
#define kNumPins 20

#define kPinModeDigitalInput 0
#define kPinModeDigitalOutput 1
#define kPinModeAnalogInput 2
#define kPinModeAnalogOutput 3
#define kPinModeBuzzer 4
#define kPinModeCompass 5
#define kPinModeUndefined 6

#define kBleShieldBufferSize 16

#define kPinValueDefault 5

#define kBuzzerMaxFrequency 20000
#define kBuzzerMinFrequency 20

#define kAccelerometerMin 1000
#define kAccelerometerMax 2000

#define kCompassMin 1000
#define kCompassMax 2000

#define kAnalogInMin 1000
#define kAnalogInMax 2000

#define kSendBufferSize 40

byte pinModes[kNumPins];
byte pinValues[kNumPins];

LSM303 compass;

void setup() {
  
  if(typeBLE == 0) { 
    bleShield.begin(14400);//BLE shield BAUD rate
    Serial.begin(9600); //Serial for debug
  }
  else if (typeBLE == 1) {
    Serial.begin(19200);// BLEbee BAUD rate
     bleShield.begin(9600);//software serial for debug (because BLE chip is connected to real serial)
  }

  Wire.begin();
  
  currentState = kStatePinModes;
 
  sendToDebug("--starting--");
}

void fillAccelerometerValues(byte sendValues[], int sendCnt){
    int x = constrain((int)compass.a.x + (int)kAccelerometerMin,0, (int)kAccelerometerMax);
    int y = constrain((int)compass.a.y + (int)kAccelerometerMin,0, (int)kAccelerometerMax);
    int z = constrain((int)compass.a.z + (int)kAccelerometerMin,0, (int)kAccelerometerMax);

    byte x1 = x >> 8;
    byte x2 = x & 0xFF;

    byte y1 = y >> 8;
    byte y2 = y & 0xFF;

    byte z1 = z >> 8;
    byte z2 = z & 0xFF;

    sendValues[sendCnt++] = x1;
    sendValues[sendCnt++] = x2;
    
    sendValues[sendCnt++] = y1;
    sendValues[sendCnt++] = y2;
    
    sendValues[sendCnt++] = z1;
    sendValues[sendCnt++] = z2;
    
    /*
    Serial.print(compass.a.x);
    Serial.print(" ");
    Serial.print(compass.a.y);
    Serial.print(" ");
    Serial.println(compass.a.z);*/
}

void fillMagnetometerValues(byte sendValues[], int sendCnt){
    int x = constrain((int)compass.m.x + (int)kCompassMin,0, (int)kCompassMax);
    int y = constrain((int)compass.m.y + (int)kCompassMin,0, (int)kCompassMax);
    int z = constrain((int)compass.m.z + (int)kCompassMin,0, (int)kCompassMax);

    byte x1 = x >> 8;
    byte x2 = x & 0xFF;

    byte y1 = y >> 8;
    byte y2 = y & 0xFF;

    byte z1 = z >> 8;
    byte z2 = z & 0xFF;

    sendValues[sendCnt++] = x1;
    sendValues[sendCnt++] = x2;
    
    sendValues[sendCnt++] = y1;
    sendValues[sendCnt++] = y2;
    
    sendValues[sendCnt++] = z1;
    sendValues[sendCnt++] = z2;
    /*
    Serial.print(compass.m.x);
    Serial.print(" ");
    Serial.print(compass.m.y);
    Serial.print(" ");
    Serial.println(compass.m.z);*/
}

void fillHeading(byte sendValues[], int sendCnt){
  int heading = compass.heading((LSM303::vector){0,-1,0});
  
  //Serial.println(heading);
  
  byte x1 = heading >> 8;
  byte x2 = heading & 0xFF;
    
  sendValues[sendCnt++] = x1;
  sendValues[sendCnt++] = x2;
  
  //Serial.println(heading);
}

void sendPinValues() {
  
  int sendCnt = 0;
  byte sendValues[kSendBufferSize];
  
  //DIGITAL
  for(int i = 0; i < kNumDigitalPins ; i++){
    
    if(pinModes[i] == kPinModeDigitalInput){
      int newval = digitalRead(i);

      if(pinValues[i] != newval){
        if(pinValues[i] != kPinValueDefault){
          sendValues[sendCnt++] = i;
          sendValues[sendCnt++] = newval;
        }
        pinValues[i] = newval;
        //Serial.println(newval);
      }
    }
  }

  //ANALOG
  for(int i = 0; i < kNumAnalogPins ; i++){
    int pinNumber = kNumDigitalPins + i;
  
    if(pinModes[pinNumber] == kPinModeAnalogInput){
      
       int newval = analogRead(A0 + i);
       newval = constrain(newval + (int)kAnalogInMin,0, (int)kAnalogInMax);
       byte x1 = newval >> 8;
       byte x2 = newval & 0xFF;
  
       sendValues[sendCnt++] = pinNumber; 
       sendValues[sendCnt++] = x1;
       sendValues[sendCnt++] = x2;
  
    } else if(pinModes[pinNumber] == kPinModeCompass){
        sendValues[sendCnt++] = pinNumber;

        compass.read();
        fillAccelerometerValues(sendValues,sendCnt);
        sendCnt += 6;
        fillHeading(sendValues,sendCnt);
        sendCnt += 2;
    }
  }

  //SEND 
  for(int i = 0; i < sendCnt ; i++){
    int val = sendValues[i];
    
    sendToBLE(val);
    String msg = "pin ";
    msg += i;
    msg += " = ";
    msg += val;
    sendToDebug(msg);
  }
  
  //FILL 
  if(sendCnt > 0){
    for(int i = sendCnt; i < kBleShieldBufferSize ; i++){
      sendToBLE(-1);
    }
  }
}
/*
int pinToFrequency(int value){
    float a = (kBuzzerMaxFrequency - kBuzzerMinFrequency ) / value;
    return a * value + kBuzzerMinFrequency;
}*/

void receivePinValues() {
  /*int availableByte == 0;
  if(typeBLE == 0) while (bleShield.available()) {
  else if(typeBLE == 1) while (serial.available()) {
    */
    
  while (Serial.available()) {
    int val = Serial.read();
    //Serial.println(val);
    
    recvCount ++;
    
    if(recvCount == 1){
      if(val == kMsgPinModeStarted){
        
        sendToDebug("--switching to pin modes--");
        currentState = kStatePinModes;
        recvCount = 0;
        
      } else {
        currPin = val;
      }
    } else if(recvCount == 2){
      
      recvCount = 0;
      if(pinModes[currPin] == kPinModeDigitalOutput){
        digitalWrite(currPin,val);
      } else if(pinModes[currPin] == kPinModeAnalogOutput){
        analogWrite(currPin,val);
      } else if(pinModes[currPin] == kPinModeBuzzer){
        if(val == 255){
          noTone(currPin);
        } else{
          float freq = map(val,0,255,kBuzzerMinFrequency,kBuzzerMaxFrequency);
          tone(currPin,freq);
        }
      } else if(pinModes[currPin] == kPinModeCompass){
          
          sendToDebug("starting compass");
          Wire.begin();
          compass.init();
          compass.enableDefault();
      }
    }
  }
}

void receivePinModes() {

if (Serial.available()) {
    int val = Serial.read();

     if(val == kMsgPinModeStarted){
       sendToDebug("--starting with pin modes--");
       for(int i = 0; i < kNumPins ; i++){
          pinValues[i] = kPinValueDefault;
          pinModes[i] = kPinModeUndefined;
       }
     } else {
    
       recvCount ++;
      
      if(val == kMsgPinValueStarted){
       
          sendToDebug("--switching to normal--");
          currentState = kStatePinValues;
          recvCount = 0;
       } else {
          if(recvCount == 1){
            currPin = val;
          } else if(recvCount == 2){
               String msg = "";
                msg += currPin;
                msg += " to mode ";
                msg += val;
                sendToDebug(msg);
                        
            recvCount = 0;
            if(val == kPinModeDigitalOutput){
              pinMode(currPin,val);
            } else if(val == kPinModeCompass && currPin == 19){//SCL pin
              
              sendToDebug(" Starting compass ");
              Wire.begin();
              compass.init();
              compass.enableDefault();
            }
            
            pinModes[currPin] = val;        
          }
        }
      }
  }
}

void sendToBLE(int val) {
  if(typeBLE == 0) {
    bleShield.write(val);
  }
  
  else if(typeBLE == 1) {
    Serial.write(val);
  }
}

void sendToDebug(String val) {
  if(typeBLE == 0) {
    Serial.println(val);
  }
  
  else if(typeBLE == 1) {
    bleShield.println(val);
  }
}

void loop() {

  if(currentState == kStatePinModes){
    receivePinModes();
  } else if(currentState == kStatePinValues){
    
    unsigned long currentMillis = millis();
  
    if(currentMillis - previousMillis > interval) {
      previousMillis = currentMillis;   
      sendPinValues();
    }
  
    receivePinValues();
  }
}

//useful functions
/*
constrain(val,min,max);
map(val,min,max,outmin,outmax);
*/
