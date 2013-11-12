#include "eGMCP.h"
#include "SoftwareSerial.h"
#include <Boards.h>
#include <Servo.h>
#include <Wire.h>

#define I2C_WRITE B00000000
#define I2C_READ B00001000
#define I2C_READ_CONTINUOUSLY B00010000
#define I2C_STOP_READING B00011000
#define I2C_READ_WRITE_MODE_MASK B00011000
#define I2C_10BIT_ADDRESS_MODE_MASK B00100000

/*==============================================================================
 * GLOBAL VARIABLES
 *============================================================================*/

/* analog inputs */
int analogInputsToReport = 0; // bitwise array to store pin reporting

/* digital input ports */
boolean reportPINs[TOTAL_PINS];
boolean previousPINs[TOTAL_PINS];

/* pins configuration */
byte pinConfig[TOTAL_PINS];         // configuration of every pin
//int pinState[TOTAL_PINS];           // any value that has been written

/* timer variables */
unsigned long currentMillis;
unsigned long previousMillis = 0; 
unsigned long previousMillisBle = 0; 

unsigned long bleInterval = 40;
unsigned long reportInterval = 160;

Servo servos[MAX_SERVOS];

/*==============================================================================
 * FUNCTIONS
 *============================================================================*/

void outputPin(byte pin, byte value){
  if(previousPINs[pin] != value){
    byte buf[3];
    
    buf[0] = DIO_INPUT;
    buf[1] = pin;
    buf[2] = value;
    
    myeGMCP.bleSendWithCRC(buf, 3);
    previousPINs[pin] = value;
  }
} 

void checkDigitalInputs(void) {
  if (TOTAL_PINS > 4 && reportPINs[4]) outputPin(4, digitalRead(4));
  if (TOTAL_PINS > 5 && reportPINs[5]) outputPin(5, digitalRead(5));
  if (TOTAL_PINS > 6 && reportPINs[6]) outputPin(6, digitalRead(6));
  if (TOTAL_PINS > 7 && reportPINs[7]) outputPin(7, digitalRead(7));
  if (TOTAL_PINS > 8 && reportPINs[8]) outputPin(8, digitalRead(8));
  if (TOTAL_PINS > 9 && reportPINs[9]) outputPin(9, digitalRead(9));
  if (TOTAL_PINS > 10 && reportPINs[10]) outputPin(10, digitalRead(10));
  if (TOTAL_PINS > 11 && reportPINs[11]) outputPin(11, digitalRead(11));
}

void setPinModeCallback(byte pin, int mode)
{
  Serial.print("setting pin mode for ");
  Serial.print(pin);
  Serial.print(" ");
  Serial.println(mode);
  
  if (pinConfig[pin] == MODE_I2C && myeGMCP.getIsI2CEnabled() && mode != MODE_I2C) {
    // disable i2c so pins can be used for other functions
    // the following if statements should reconfigure the pins properly
    myeGMCP.disableI2CPins();
  }
  if (IS_PIN_SERVO(pin) && mode != MODE_SERVO && servos[PIN_TO_SERVO(pin)].attached()) {
    servos[PIN_TO_SERVO(pin)].detach();
  }
  if (IS_PIN_ANALOG(pin)) {
    analogReportCallback(PIN_TO_ANALOG(pin), mode == MODE_ANALOG ? 1 : 0); // turn on/off reporting
  }
  
  /*
  if (IS_PIN_DIGITAL(pin)) {
    if (mode == MODE_INPUT) {
      portConfigInputs[pin/8] |= (1 << (pin & 7));
    } else {
      portConfigInputs[pin/8] &= ~(1 << (pin & 7));
    }
  }*/
  
  //pinState[pin] = 0;
  
  switch(mode) {
  case MODE_ANALOG:
    if (IS_PIN_ANALOG(pin)) {
      if (IS_PIN_DIGITAL(pin)) {
        pinMode(PIN_TO_DIGITAL(pin), MODE_INPUT); // disable output driver
        digitalWrite(PIN_TO_DIGITAL(pin), LOW); // disable internal pull-ups
      }
      pinConfig[pin] = MODE_ANALOG;
    }
    break;
  case MODE_INPUT:
  
    if (IS_PIN_DIGITAL(pin)) {
  
      pinMode(PIN_TO_DIGITAL(pin), MODE_INPUT); // disable output driver
      digitalWrite(PIN_TO_DIGITAL(pin), LOW); // disable internal pull-ups
      pinConfig[pin] = MODE_INPUT;
    }
    break;
  case MODE_OUTPUT:  
    if (IS_PIN_DIGITAL(pin)) {
      digitalWrite(PIN_TO_DIGITAL(pin), LOW); // disable PWM
      pinMode(PIN_TO_DIGITAL(pin), MODE_OUTPUT);
      pinConfig[pin] = MODE_OUTPUT;
    }
    break;
  case MODE_PWM:
  
    if (IS_PIN_PWM(pin)) {
      pinMode(PIN_TO_PWM(pin), MODE_OUTPUT);
      analogWrite(PIN_TO_PWM(pin), 0);
      pinConfig[pin] = MODE_PWM;
    }
    break;
  case MODE_SERVO:
      Serial.print("servo enters");
      
    if (IS_PIN_SERVO(pin)) {
      pinConfig[pin] = MODE_SERVO;
      if (!servos[PIN_TO_SERVO(pin)].attached()) {
          servos[PIN_TO_SERVO(pin)].attach(PIN_TO_DIGITAL(pin));
      }
    }
    break;
  case MODE_I2C:
    if (IS_PIN_I2C(pin)) {
      Serial.println("marking pin as i2c");
      // mark the pin as i2c
      // the user must call I2C_CONFIG to enable I2C for a device
      pinConfig[pin] = MODE_I2C;
    }
    break;
  default:
    Serial.println("Unknown pin mode"); // TODO: put error msgs in EEPROM
  }
}


void pinModeQueryCallback(byte pin, int notUsed){
  
  if (pin < TOTAL_PINS) {
    byte reply[3];
     
     
    reply[0] = PIN_MODE_RESPONSE;  
    reply[1] = pin;
    reply[2] = (byte)pinConfig[pin];
    
    myeGMCP.bleSendWithCRC(reply, 3);
    
    
  Serial.print("sending mode ");
  Serial.print(pin);
  Serial.print(" ");
  Serial.print(reply[2]);
  Serial.println();
  }
}

void analogWriteCallback(byte pin, int value)
{
  Serial.print("analog write ");
  Serial.print(pin);
  Serial.print(" ");
  Serial.print(value);
  Serial.println();
  
  if (pin < TOTAL_PINS) {
    switch(pinConfig[pin]) {
      
    case MODE_SERVO:
      if (IS_PIN_SERVO(pin))
        servos[PIN_TO_SERVO(pin)].write(value);
      //pinState[pin] = value;
      break;
    case MODE_PWM:
      if (IS_PIN_PWM(pin)){
        analogWrite(PIN_TO_PWM(pin), value);
      }
       //pinState[pin] = value;
      break;
    }
  }
}

void digitalWriteCallback(byte pin, int value) {
  /*
  Serial.print("digital write ");
  Serial.print(pin);
  Serial.print(" ");
  Serial.print(value);
  Serial.println();*/
  
  digitalWrite(pin,value);
}

void analogReadCallback(byte pin, int notUsed){
  
    Serial.println("Analog read\n");
    
     if(IS_PIN_ANALOG(pin) && pinConfig[pin] == MODE_ANALOG){
        
        byte reply[4];
        byte buf[2];
        
        int value = analogRead(pin);
        myeGMCP.valueAsTwo7bitBytes(value,buf);
        
        reply[0] = ADC_READ;
        reply[1] = PIN_TO_ANALOG(pin);;
        reply[2] = buf[0];
        reply[3] = buf[1];
        
        myeGMCP.bleSendWithCRC(reply, 4);
    }
}
void analogReportCallback(byte analogPin, int value)
{    
  analogPin = PIN_TO_ANALOG(analogPin);
    
  if (analogPin < TOTAL_ANALOG_PINS) {
    
    if(value == 0) {
      analogInputsToReport = analogInputsToReport &~ (1 << analogPin);
    } else {
      analogInputsToReport = analogInputsToReport | (1 << analogPin);
    }
  }
  // TODO: save status to EEPROM here, if changed
}

void digitalReadCallback(byte pin, int value) {
  
    Serial.print("digital read ");
    Serial.println(pin);
    
  if(pin < TOTAL_PINS){
    outputPin(pin,value);
    /*
    uint8_t reply[3];
    
    reply[0] = DIO_INPUT;
    reply[1] = pin;
    reply[2] = digitalRead(pin);
    
    myeGMCP.bleSendWithCRC(reply, 3);*/
  }
}

void digitalReportCallback(byte pin, int value) {
     
    Serial.print("digital report ");
    Serial.println(pin);
    
  if (pin < TOTAL_PINS) {
  
    
    reportPINs[pin] = (byte)value;
  }
  // do not disable analog reporting on these 8 pins, to allow some
  // pins used for digital, others analog.  Instead, allow both types
  // of reporting to be enabled, but check if the pin is configured
  // as analog when sampling the analog inputs.  Likewise, while
  // scanning digital pins, portConfigInputs will mask off values from any
  // pins configured as analog
  
}

/*
void sysexCallback(byte command, byte argc, byte *argv)
{
  byte mode;
  byte slaveAddress;
  byte slaveRegister;
  byte data;
  unsigned int delayTime; 
  
  switch(command) {
    
  case I2C_REQUEST:
    mode = argv[1] & I2C_READ_WRITE_MODE_MASK;
    if (argv[1] & I2C_10BIT_ADDRESS_MODE_MASK) {
      Serial.println("10-bit addressing mode is not yet supported");
      return;
    }
    else {
      slaveAddress = argv[0];
    }

    switch(mode) {
    case I2C_WRITE:
            
      Wire.beginTransmission(slaveAddress);
      for (byte i = 2; i < argc; i += 2) {
        data = argv[i] + (argv[i + 1] << 7);
                
        #if ARDUINO >= 100
        Wire.write(data);
        #else
        Wire.send(data);
        #endif
      }
            
      Wire.endTransmission();
      delayMicroseconds(70);
      break;
      
    case I2C_READ:
      if (argc == 6) {
        // a slave register is specified
        slaveRegister = argv[2] + (argv[3] << 7);
        data = argv[4] + (argv[5] << 7);  // bytes to read
        readAndReportData(slaveAddress, (int)slaveRegister, data);
      }
      else {
        // a slave register is NOT specified
        data = argv[2] + (argv[3] << 7);  // bytes to read
        readAndReportData(slaveAddress, (int)REGISTER_NOT_SPECIFIED, data);
      }
      break;
    case I2C_READ_CONTINUOUSLY:
    
      if ((queryIndex + 1) >= MAX_QUERIES) {
        // too many queries, just ignore
        //Serial.println("too many queries");
        break;
      }
      queryIndex++;
      query[queryIndex].addr = slaveAddress;
      query[queryIndex].reg = argv[2] + (argv[3] << 7);
      query[queryIndex].bytes = argv[4] + (argv[5] << 7);
    
      break;
    case I2C_STOP_READING:
        
	  byte queryIndexToSkip;      
      // if read continuous mode is enabled for only 1 i2c device, disable
      // read continuous reporting for that device
      if (queryIndex <= 0) {
        queryIndex = -1;        
      } else {
        // if read continuous mode is enabled for multiple devices,
        // determine which device to stop reading and remove it's data from
        // the array, shifiting other array data to fill the space
        for (byte i = 0; i < queryIndex + 1; i++) {
          if (query[i].addr = slaveAddress) {
            queryIndexToSkip = i;
            break;
          }
        }
        
        for (byte i = queryIndexToSkip; i<queryIndex + 1; i++) {
          if (i < MAX_QUERIES) {
            query[i].addr = query[i+1].addr;
            query[i].reg = query[i+1].addr;
            query[i].bytes = query[i+1].bytes; 
          }
        }
        queryIndex--;
      }
      break;
    default:
      break;
    }
    break;
  case I2C_CONFIG:
    delayTime = (argv[0] + (argv[1] << 7));

    if(delayTime > 0) {
      i2cReadDelayTime = delayTime;
    }

    if (!isI2CEnabled) {
      enableI2CPins();
    }
    
    break;
  case SERVO_CONFIG:
    if(argc > 4) {
      // these vars are here for clarity, they'll optimized away by the compiler
      byte pin = argv[0];
      int minPulse = argv[1] + (argv[2] << 7);
      int maxPulse = argv[3] + (argv[4] << 7);

      if (IS_PIN_SERVO(pin)) {
        if (servos[PIN_TO_SERVO(pin)].attached())
          servos[PIN_TO_SERVO(pin)].detach();
        servos[PIN_TO_SERVO(pin)].attach(PIN_TO_DIGITAL(pin), minPulse, maxPulse);
        setPinModeCallback(pin, SERVO);
      }
    }
    break;
  case SAMPLING_INTERVAL:
    if (argc > 1) {
      samplingInterval = argv[0] + (argv[1] << 7);
      if (samplingInterval < MINIMUM_SAMPLING_INTERVAL) {
        samplingInterval = MINIMUM_SAMPLING_INTERVAL;
      }      
    } else {
      //iFirmata.sendString("Not enough data");
    }
    break;
  case EXTENDED_ANALOG:
    if (argc > 1) {
      int val = argv[1];
      if (argc > 2) val |= (argv[2] << 7);
      if (argc > 3) val |= (argv[3] << 14);
      analogWriteCallback(argv[0], val);
    }
    break;
  }
}
*/

void systemResetCallback()
{
  Serial.println("resets");
  
  // initialize a defalt state
  // TODO: option to load config from EEPROM instead of default
  if (myeGMCP.getIsI2CEnabled()) {
  	myeGMCP.disableI2CPins();
  }
  
  for (byte i=0; i < TOTAL_PINS; i++) {
    reportPINs[i] = false;      // by default, reporting off
    //portConfigInputs[i] = 0;	// until activated
    previousPINs[i] = 0;
  }
  
  // pins with analog capability default to analog input
  // otherwise, pins default to digital output
  for (byte i=4; i < TOTAL_PINS; i++) {
    if (IS_PIN_ANALOG(i)) {
      // turns off pullup, configures everything
      setPinModeCallback(i, MODE_ANALOG);
    } else {
      // sets the output to 0, configures portConfigInputs
      setPinModeCallback(i, MODE_OUTPUT);
    }
  }
  
  // by default, do not report any analog inputs
  analogInputsToReport = 0;
}

void setup()
{
  Serial.begin(9600);

  myeGMCP.attach(PIN_MODE_QUERY, pinModeQueryCallback);
  myeGMCP.attach(PIN_MODE_SET, setPinModeCallback);
  myeGMCP.attach(DIO_OUTPUT, digitalWriteCallback);
  myeGMCP.attach(DAC_WRITE, analogWriteCallback);
  myeGMCP.attach(DIO_INPUT, digitalReadCallback);
  myeGMCP.attach(DIO_INPUT_STREAM, digitalReportCallback);
  myeGMCP.attach(ADC_READ, analogReadCallback);
  myeGMCP.attach(ADC_READ_STREAM, analogReportCallback);
  
  myeGMCP.attachResetCallback(systemResetCallback);

  myeGMCP.begin();
  
  systemResetCallback();  // reset to default config */ 
}


/*==============================================================================
 * LOOP()
 *============================================================================*/
void loop() {
  byte pin, analogPin;
  
  while(myeGMCP.available()){
    myeGMCP.processInput();
  }

  currentMillis = millis();
  if(myeGMCP.isConnected()){
    if(currentMillis - previousMillisBle > bleInterval) {
      
      previousMillisBle = currentMillis;
      
      if(currentMillis - previousMillis > reportInterval) {
        
         previousMillis = currentMillis;
      
         checkDigitalInputs();
      
         for(pin=0; pin<TOTAL_PINS; pin++) {
          if (IS_PIN_ANALOG(pin) && pinConfig[pin] == MODE_ANALOG) {
             analogPin = PIN_TO_ANALOG(pin);
             if (analogInputsToReport & (1 << analogPin)) {
               myeGMCP.sendAnalog(analogPin, analogRead(analogPin));
             }
           }
         }
    
         myeGMCP.reportI2CData();
         myeGMCP.bleSendOver();
      }
    
      myeGMCP.bleFlush();
     }
  }
}
