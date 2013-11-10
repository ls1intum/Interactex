#ifndef __EGMCP_H__
#define __EGMCP_H__ 

#include <stdint.h>
#include <SoftwareSerial.h>
#include "Boards.h"
#include <Wire.h>

#define TOTAL_PIN_MODES 7
#define DELIMITER   0xAA
#define PAYLOAD_LEN  16
#define SEND_BUFFER_SIZE 64
#define BLE_BUFFER_SIZE 16

//message type
typedef enum
{
	FIRMWARE_QUERY = 0x00,
	FIRMWARE_RESPONSE,
	CAPABILITY_QUERY,
	CAPABILITY_RESPONSE,
	CREATE_GROUP_REQUEST,
	CREATE_GROUP_RESPONSE,
	PIN_MODE_SET,
	PIN_MODE_QUERY,
	PIN_MODE_RESPONSE,
	DIO_INPUT,
	DIO_INPUT_STREAM,
	DIO_OUTPUT,
	ADC_READ,
	ADC_READ_STREAM,
	DAC_WRITE,
	PWM_CONFIG,
	I2C_CONFIG,
	I2C_READ,
	I2C_READ_STREAM,
	I2C_WRITE,
	I2C_WRITE_STREAM,
	I2C_STOP_STREAM,
	SPI_CONFIG,
	SPI_READ,
	SPI_WRITE,
	UART_CONFIG,
	UART_READ,
	UART_WRITE,
	HW_TIMER_CONFIG,
	WATCHDOG_CONFIG,
	SYSTEM_RESET,
	CLK_CONFIG,
	ACK_ENABLE = 0x80,
	ACK = 0x81,
}packet_type_t;

// pin modes
// bit 0 1:digital (gpio),  
// bit 3~1 001: pwm, 010: adc, 011: dac, 100: comperator 
// bit 7~4 0001: uart, 0010: spi, 0100: i2c, 1000: one wire 
typedef enum{
	_GPIO = 0x01,
	_PWM  = 0x02,
	_ADC = 0x04,
	_DAC  = 0x06,
	_COMP = 0x08,
	_UART = 0x10,
	_SPI  = 0x20,
	_I2C	 = 0x40,
	_ONE_WIRE = 0x80
}capability_t;

typedef enum{
    MODE_INPUT = 0x00,
    MODE_OUTPUT = 0x01,
    MODE_ANALOG = 0x02,
    MODE_PWM = 0x03,
    MODE_SERVO = 0x04,
    MODE_SHIFT = 0x05,
    MODE_I2C = 0x06
}pin_mode_t;


extern "C" {
    // callback function types
    typedef void (*callbackFunction)(byte, int);
    typedef void (*resetCallbackFunction)();
}

typedef struct
{
    uint8_t index;
    uint8_t mode;
    //aux in adc and dac are the index of the peripheral in system; for comparator: low 4bits are index, high 4bits 0: reference, 1: input;
    //for spi 0: clk, 1:miso, 2:mosi, 3:ssz, 4:ssm, 5:swp
    //dio: ignore aux
    uint8_t aux;   //aux in adc and dac are the index of the peripheral in system; for comparator: low 4bits are index, high 4bits 0: reference, 1: input;
} pin_t;

typedef struct 
{
	uint8_t pins[8];
}group_t;

typedef struct 
{
	uint8_t len;
	uint8_t type;
	uint8_t payload[PAYLOAD_LEN];
	uint16_t crc;
}packet_t;

#define MAX_QUERIES 8
#define MAX_I2C_REPLIES 16
#define REGISTER_NOT_SPECIFIED -1

/* i2c data */
struct i2c_device_info {
    byte addr;
    byte reg;
    byte bytes;
};

class eGMCP
{
public:
	eGMCP(SoftwareSerial &ss);
    ~eGMCP();
    
    void begin();
	void eGMCPHandler(packet_t *pkt);
    void bleSendWithCRC(byte *bytes, int count);
    int available(void);
    void processInput(void);
    void bleFlush();
    bool getIsI2CEnabled();
    void reportI2CData();
    void enableI2CPins(void);
    void disableI2CPins(void);
    
    //helper
    void sendAnalog(byte pin, int value);
    void valueAsTwo7bitBytes(int value, byte buf[2]);
    
    /* attach & detach callback functions to messages */
    void attach(byte command, callbackFunction newFunction);
    void attachResetCallback(resetCallbackFunction newFunction);
    void detach(byte command);
    
    private:
    
    SoftwareSerial &softwareSerial;
    
    
	uint16_t crcByte(uint16_t crc, uint8_t b);
	void btSendPkt(uint8_t *data, uint8_t len);
	//group_t groups[5];
	//uint8_t group_index;
	uint8_t buf_index;
    
    //send buffer
    int sendBufferStart;
    int sendBufferCount;
    byte sendBuffer[SEND_BUFFER_SIZE];
    
    
    uint16_t calculateCRCForBytes(byte *bytes, int count);
    void crcPackageForBytes(byte *bytes, int count, byte *crcBytes);
    void systemReset(void);
    
    //i2c
    /* for i2c read continuous more */
    i2c_device_info query[MAX_QUERIES];
    byte i2cReply[MAX_I2C_REPLIES];
    boolean isI2CEnabled;
    signed char queryIndex;
    unsigned int i2cReadDelayTime;
    void readAndReportI2CData(byte address, byte theRegister, byte numBytes);
    void writeI2CData(packet_t *pkt);
    
    //firmata
    void handleFirmwareQuery();
    void handleCapabilitiesQuery();
    void handleSetPinModeRequestForPins(packet_t *pkt);
    void handlePinModeQueryForPins(packet_t *pkt);
    void stopStreamingI2CDataForAddress(byte address);
    
    void handleGroupRequest();
    void handleI2CConfigRequest(unsigned int delayTime);
    
    //callbacks
    callbackFunction currentSetPinModeCallback;
    callbackFunction currentPinModeQueryCallback;
    callbackFunction currentDigitalWriteCallback;
    callbackFunction currentAnalogWriteCallback;
    callbackFunction currentDigitalReadCallback;
    callbackFunction currentDigitalReportCallback;
    callbackFunction currentAnalogReadCallback;
    callbackFunction currentAnalogReportCallback;
    resetCallbackFunction currentSystemResetCallback;
};


extern SoftwareSerial ble;
extern eGMCP myeGMCP;

#endif


