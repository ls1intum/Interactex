#include "eGMCP.h"
#include <string.h>
#include <HardwareSerial.h>


#define MAX(a,b) \
({ __typeof__ (a) _a = (a); \
__typeof__ (b) _b = (b); \
_a > _b ? _a : _b; })

#define MIN(a,b) \
({ __typeof__ (a) _a = (a); \
__typeof__ (b) _b = (b); \
_a < _b ? _a : _b; })


/*
#if DEBUG
SoftwareSerial ble(2, 3);
void PRINTF(char *fmt, ... )
{
    char tmp[128]; // resulting string limited to 128 chars
    va_list args;
    va_start (args, fmt );
    vsnprintf(tmp, 128, fmt, args);
    va_end (args);
    Serial.print(tmp);
}
#else
#define PRINTF(...)
#endif*/

static int valid_pkt_count, invalid_pkt_count;

void eGMCP::valueAsTwo7bitBytes(int value, byte buf[2])
{
    buf[0] = value & B01111111;
    buf[1] = value >> 7 & B01111111;
}

uint16_t eGMCP::crcByte(uint16_t crc, uint8_t b)
{
    crc = (uint8_t)(crc >> 8) | (crc << 8);
    crc ^= b;
    crc ^= (uint8_t)(crc & 0xff) >> 4;
    crc ^= crc << 12;
    crc ^= (crc & 0xff) << 5;
    return crc;
}


uint16_t eGMCP::calculateCRCForBytes(byte *bytes, int count){
    
    uint16_t crc = 0;
    
    for (int i = 0; i < count; i++) {
        uint8_t b = bytes[i];
        
        crc = crcByte(crc,b);
    }
    return crc;
}

void eGMCP::crcPackageForBytes(byte *bytes, int count, byte *crcBytes){
    
    crcBytes[0] = DELIMITER;
    crcBytes[1] = count;
    
    memcpy(crcBytes + 2, bytes, count);
    
    uint16_t crcValue = calculateCRCForBytes(crcBytes+1, count+1);
    
    uint8_t firstByte = (crcValue & 0xFF00) >> 8;
    uint8_t secondByte = (crcValue & 0x00FF);
    
    crcBytes[count+2] = firstByte;
    crcBytes[count+3] = secondByte;
}

void eGMCP::bleSendWithCRC(byte *bytes, int count){
    
    int length = count + 4;
    byte crcBytes[length];
    crcPackageForBytes(bytes, count, crcBytes);
    
    int idx = (sendBufferStart + sendBufferCount) % SEND_BUFFER_SIZE;
    for (int i = 0; i < length; i++) {
        sendBuffer[idx] = crcBytes[i];
        idx = (idx + 1) % SEND_BUFFER_SIZE;
    }
    sendBufferCount += length;
    if(sendBufferCount >= SEND_BUFFER_SIZE){
        Serial.println("buffer reaching limits");
        sendBufferCount = SEND_BUFFER_SIZE;
    }
}

void eGMCP::bleFlush(void)
{
    if(sendBufferCount > 0){
        
        byte buf[BLE_BUFFER_SIZE];
        
        int numBytesSend = MIN(BLE_BUFFER_SIZE,sendBufferCount);
        
        //totalBytesSent += numBytesSend;
        
        if(sendBufferStart + numBytesSend > SEND_BUFFER_SIZE){
            
            int firstPartSize = SEND_BUFFER_SIZE - sendBufferStart ;
            
            memcpy(buf,&sendBuffer[0] + sendBufferStart,firstPartSize);
            memcpy(&buf[0] + firstPartSize,&sendBuffer[0],numBytesSend-firstPartSize);
            
        } else {
            memcpy(&buf[0],&sendBuffer[0] + sendBufferStart,numBytesSend);
            
        }
        
        //fill buffer to BLE_BUFFER_SIZE so it notifies
        int missing = BLE_BUFFER_SIZE - numBytesSend;
        if(missing > 0) {
            memset(buf+numBytesSend,0,missing);
        }
        
        softwareSerial.write(&buf[0],BLE_BUFFER_SIZE);
        
        sendBufferCount -= numBytesSend;
        sendBufferStart = (sendBufferStart + numBytesSend) % SEND_BUFFER_SIZE;
    }
}

void eGMCP::sendAnalog(byte pin, int value){
    byte buf[4];
    buf[0] = ADC_READ;
    
    buf[1] = pin;
    
    byte valueBuf[2];
    valueAsTwo7bitBytes(value,valueBuf);
    buf[2] = valueBuf[0];
    buf[3] = valueBuf[1];
    
    bleSendWithCRC(buf, 4);
}

const char firmware_name[] = "eGMCP1.0";

void eGMCP::handleFirmwareQuery(){
    
    Serial.println("Firmware query packet received\n");
    uint8_t reply[1+strlen(firmware_name)];
    
    byte i = 0;
    
    reply[i++] = FIRMWARE_RESPONSE;
    for(byte j = 0; j < strlen(firmware_name); j++)     {
        reply[i++] = firmware_name[j];
    }
    
    bleSendWithCRC(reply, i);
}

void eGMCP::handleCapabilitiesQuery(){
    
    Serial.println("Capability query packet received\n");
    
    byte size = TOTAL_PINS * 3 + 1;
    uint8_t reply[size];
    
    byte i = 0;
    reply[i++] = CAPABILITY_RESPONSE;
    
    for (byte pin = 0; pin < TOTAL_PINS; pin++) {
        reply[i++] = pin;
        
        byte capabilities;
        
        if (IS_PIN_DIGITAL(pin)) {
            capabilities |= _GPIO;
        }
        if (IS_PIN_ANALOG(pin)) {
            capabilities |= _ADC;
        }
        if (IS_PIN_PWM(pin)) {
            capabilities |= _PWM;
        }
        
        if (IS_PIN_SERVO(pin)) {
        }
        
        if (IS_PIN_I2C(pin)) {
            capabilities |= _I2C;
        }
        
        reply[i++] = capabilities;
        reply[i++] = 0;
    }
    
    bleSendWithCRC(reply, size);
}

void eGMCP::handleGroupRequest() {
    Serial.println("Group creating request packet received\n");
    /*
    byte i = 0;
    for(j = 0; j < pkt->payload[0]; j++)     {
        groups[group_index].pins[j] = pkt->payload[j+1];
    }
    i = 0;
    reply[i++] = CREATE_GROUP_RESPONSE;
    reply[i++] = group_index++;
    
    bleSendWithCRC(reply, i);*/
}

void eGMCP::handleI2CConfigRequest(unsigned int delayTime){
    
    if(delayTime > 0) {
        i2cReadDelayTime = delayTime;
    }
    
    if (!isI2CEnabled) {
        enableI2CPins();
    }
    
    Serial.println("i2c config\n");
}

void eGMCP::handleSetPinModeRequestForPins(packet_t *pkt){
    
    if(currentSetPinModeCallback){
        byte numPins = pkt->payload[0];
        
        for(byte i = 0 ; i < numPins ; i++){
            
            byte pin = pkt->payload[2*i+1];
            byte mode = pkt->payload[2*i+2];
            
            (*currentSetPinModeCallback)(pin, (int)mode);
        }
    }
}

void eGMCP::handlePinModeQueryForPins(packet_t *pkt){
    
    if(currentPinModeQueryCallback){
        byte numPins = pkt->payload[0];
        
        for(byte i = 0 ; i < numPins ; i++){
            
            byte pin = pkt->payload[i+1];
            
            (*currentPinModeQueryCallback)(pin, 0);
        }
    }
}

//i2c

void eGMCP::readAndReportI2CData(byte address, byte theRegister, byte numBytes) {
    
    // allow I2C requests that don't require a register read
    // for example, some devices using an interrupt pin to signify new data available
    // do not always require the register read so upon interrupt you call Wire.requestFrom()
    /*
    Serial.print("reporting i2c ");
    Serial.print(address);
    Serial.print(" register ");
    Serial.print(theRegister);
    Serial.print(" bytes ");
    Serial.println(numBytes);*/
    
    Wire.beginTransmission(address);
#if ARDUINO >= 100
    
    Wire.write((byte)theRegister);
#else
    Wire.send((byte)theRegister);
#endif
    Wire.endTransmission();
    delayMicroseconds(i2cReadDelayTime);  // delay is necessary for some devices such as WiiNunchuck
    
    Wire.requestFrom(address, numBytes);  // all bytes are returned in requestFrom
    int bytesAvailable = Wire.available();
    
    // check to be sure correct number of bytes were returned by slave
    if(numBytes == bytesAvailable) {
        i2cReply[0] = I2C_READ;
        i2cReply[1] = address;
        i2cReply[2] = theRegister;
        //i2cRxData[3] = numBytes;
        
        for (int i = 0; i < numBytes; i++) {
#if ARDUINO >= 100
            i2cReply[3 + i] = Wire.read();
#else
            i2cReply[3 + i] = Wire.receive();
#endif
        }
    } else {/*
             Serial.print("requested: ");
             Serial.print(numBytes);
             Serial.print(" but got: ");
             Serial.println(bytesAvailable);*/
    }
    
    bleSendWithCRC(i2cReply,numBytes + 3);
    
    // send slave address, register and received bytes
    //iFirmata.sendSysex(SYSEX_I2C_REPLY, numBytes + 2, i2cRxData);
    
}

void eGMCP::reportI2CData(){
    // report i2c data for all device with read continuous mode enabled
    if (queryIndex > -1) {
        for (byte i = 0; i < queryIndex + 1; i++) {
            myeGMCP.readAndReportI2CData(query[i].addr, query[i].reg, query[i].bytes);
        }
    }
}

void eGMCP::writeI2CData(packet_t *pkt) {
    
    int data;
    
    byte address = pkt->payload[0];
    //byte reg = pkt->payload[1];
    byte numValues = pkt->payload[2];
    /*
    Serial.print("writing i2c ");
    Serial.print(address);
    Serial.print("size ");
    Serial.println(numValues);*/
    
    Wire.beginTransmission(address);

    for (byte i = 0; i < numValues; i ++) {
        data = pkt->payload[2*i+3] + (pkt->payload[2*i + 4] << 7);
        
#if ARDUINO >= 100
        Wire.write(data);
#else
        Wire.send(data);
#endif
    }
    
    Wire.endTransmission();
    delayMicroseconds(70);
}

void eGMCP::stopStreamingI2CDataForAddress(byte address){
    byte queryIndexToSkip;
    /*
    Serial.print("stopping i2c ");
    Serial.println(address);*/
    
    // if read continuous mode is enabled for only 1 i2c device, disable
    // read continuous reporting for that device
    if (queryIndex <= 0) {
        queryIndex = -1;
    } else {
        // if read continuous mode is enabled for multiple devices,
        // determine which device to stop reading and remove it's data from
        // the array, shifiting other array data to fill the space
        for (byte i = 0; i < queryIndex + 1; i++) {
            if (query[i].addr = address) {
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
}

bool eGMCP::getIsI2CEnabled(void){
    return isI2CEnabled;
}

void eGMCP::enableI2CPins(void) {
    if(currentSetPinModeCallback){
        byte i;
        // is there a faster way to do this? would probaby require importing
        // Arduino.h to get SCL and SDA pins
        for (i=0; i < TOTAL_PINS; i++) {
            if(IS_PIN_I2C(i)) {
                // mark pins as i2c so they are ignore in non i2c data requests
                
                (*currentSetPinModeCallback)(i, (int)MODE_I2C);
            }
        }
        
        isI2CEnabled = true;
        
        // is there enough time before the first I2C request to call this here?
        Wire.begin();
    }
}

void eGMCP::disableI2CPins() {
    
    isI2CEnabled = false;
    // disable read continuous mode for all devices
    queryIndex = -1;
    // uncomment the following if or when the end() method is added to Wire library
    // Wire.end();
}


void eGMCP::eGMCPHandler(packet_t *pkt)
{
    uint8_t i = 0, j = 0, k = 0;
    uint8_t i2c_buf[2];
    
    switch(pkt->type) {
            
        case FIRMWARE_QUERY:
            handleFirmwareQuery();
            break;

        case CAPABILITY_QUERY:
            handleCapabilitiesQuery();
            break;
/*
        case CREATE_GROUP_REQUEST:
            handleGroupRequest();
            break;*/

        case PIN_MODE_SET:
            handleSetPinModeRequestForPins(pkt);
            break;

        case PIN_MODE_QUERY:
            handlePinModeQueryForPins(pkt);
            break;
            
        case DIO_INPUT:{
            
            byte pin = pkt->payload[0];
            
            if(currentDigitalReadCallback)
                (*currentDigitalReadCallback)(pin, 0);
        }
            break;
            
        case DIO_INPUT_STREAM:{
            
            byte pin = pkt->payload[0];
            byte value = pkt->payload[1];
            
            if(currentDigitalReportCallback)
                (*currentDigitalReportCallback)(pin, value);
        }
            break;
            
        case DIO_OUTPUT:{
            
            byte pin = pkt->payload[0];
            byte value = pkt->payload[1];
            
            if(currentDigitalWriteCallback)
                (*currentDigitalWriteCallback)(pin, value);
        }
            break;
            
        case ADC_READ:{
            
            byte pin = pkt->payload[0];
            
            if(currentAnalogReadCallback)
                (*currentAnalogReadCallback)(pin, 0);

        }
            break;
            
        case ADC_READ_STREAM:{
            
            byte pin = pkt->payload[0];
            byte report = pkt->payload[1];
            
            if(currentAnalogReportCallback)
                (*currentAnalogReportCallback)(pin, report);
        }
            break;
            
        case DAC_WRITE:{
            
            byte pin = pkt->payload[0];
            byte value = pkt->payload[1];
            
            if(currentAnalogWriteCallback)
                (*currentAnalogWriteCallback)(pin, value);
        }
            break;
            
        case I2C_CONFIG:{
            
            unsigned int delayTime = (pkt->payload[0] + (pkt->payload[1] << 7));
            
            handleI2CConfigRequest(delayTime);
        }
            break;
            
        case I2C_READ:{
            
            byte address = pkt->payload[0];
            byte reg = pkt->payload[1];
            byte size = pkt->payload[2];
            
            readAndReportI2CData(address, reg, size);
        }
            break;
            
        case I2C_READ_STREAM: {
            if ((queryIndex + 1) < MAX_QUERIES) {
                
                queryIndex++;
                query[queryIndex].addr = pkt->payload[0];
                query[queryIndex].reg = pkt->payload[1];
                query[queryIndex].bytes = pkt->payload[2];
            }
        }
            break;
            
        case I2C_WRITE:
            writeI2CData(pkt);
            break;
            
        case I2C_STOP_STREAM:{
            byte address = pkt->payload[0];
            
            stopStreamingI2CDataForAddress(address);
        }
            break;
            
        case SYSTEM_RESET:
            if(currentSystemResetCallback)
                (*currentSystemResetCallback)();
            break;
            
        default:
            break;
    }
}

int eGMCP::available(){
    return softwareSerial.available();
}

void eGMCP::processInput()
{
    uint8_t c = softwareSerial.read();
    
    Serial.print("received: ");
    Serial.println((int)c);
    
    if(-1 == c) {
        return;
    }
    
    static uint8_t status = 0;
    static uint16_t crc = 0;
    static packet_t packet;
    static uint8_t payload_index = 0;

    
    if(0 == status && DELIMITER == c) {
        
        status++;
        packet.crc = 0;
        payload_index = 0;
        crc = 0;
        
    } else if(1 == status) {
        
        packet.len = c;
        crc = crcByte(crc, c);
        status++;
        if(c > PAYLOAD_LEN)
        {
            status = 0;
            crc = 0;
        }
        
    } else if(2 == status) {
        packet.type = c;
        status++;
        payload_index = 0;
        crc = crcByte(crc, c);
        if(1 == packet.len)///XXX check
        {
            status++;
        }
        
    } else if(3 == status) {
        packet.payload[payload_index] = c;
        crc = crcByte(crc, c);
        if(++payload_index >= (packet.len - 1))
        {
            status++;
        }
        
    } else if(4 == status) {
        
        packet.crc = c << 8;
        status++;
        
    } else if(5 == status) {
        
        packet.crc |= c;
        if(packet.crc == crc)
        {
            valid_pkt_count++;
            eGMCPHandler(&packet);
        }
        else
        {
            invalid_pkt_count++;
            Serial.println("Packet corrupted");
            //PRINTF("Packet %d is corrupted crc in packet %d, crc calculated %d\n", invalid_pkt_count, packet.crc, crc);
        }
        status = 0;
    }
    else
    {

    }
}

//resetting
void eGMCP::systemReset(void)
{
    byte i;
    
    sendBufferStart = 0;
    sendBufferCount = 0;
    
    //i2c
    queryIndex = -1;
    i2cReadDelayTime = 0;
    isI2CEnabled = false;
    
    //memset(emptySendBuffer,0,BLE_BUFFER_SIZE);
    
    /*
    receiveDataStart = 0;
    receiveDataCurrentIndex = 0;
    receiveDataCount = 0;
    receiveDataLength = 0;*/
    /*
    waitForData = 0; // this flag says the next serial input will be data
    executeMultiByteCommand = 0; // execute this after getting multi-byte data
    multiByteChannel = 0; // channel data for multiByteCommands
    */
    /*
    for(i=0; i<MAX_DATA_BYTES; i++) {
        storedInputData[i] = 0;
    }*/
    /*
    if(currentSystemResetCallback)
        (*currentSystemResetCallback)();*/
    
    //flush(); //TODO uncomment when Firmata is a subclass of HardwareSerial
}

// callbacks


void eGMCP::attachResetCallback(resetCallbackFunction newFunction){
    currentSystemResetCallback = newFunction;
}

void eGMCP::attach(byte command, callbackFunction newFunction)
{
    switch(command) {
        case PIN_MODE_QUERY: currentPinModeQueryCallback = newFunction; break;
        case PIN_MODE_SET: currentSetPinModeCallback = newFunction; break;
        case DAC_WRITE: currentAnalogWriteCallback = newFunction; break;
        case DIO_OUTPUT: currentDigitalWriteCallback = newFunction; break;
        case ADC_READ: currentAnalogReadCallback = newFunction; break;
        case DIO_INPUT: currentDigitalReadCallback = newFunction; break;
        case DIO_INPUT_STREAM: currentDigitalReportCallback = newFunction; break;
        case ADC_READ_STREAM: currentAnalogReportCallback = newFunction; break;
    }
}

void eGMCP::detach(byte command)
{
    attach(command, (callbackFunction)NULL);
}

void eGMCP::begin(){
    
    softwareSerial.begin(19200);
    
}

eGMCP::eGMCP(SoftwareSerial &ss) : softwareSerial(ss)
{
    systemReset();
}

eGMCP::~eGMCP()
{

}

extern SoftwareSerial ss(2,3);
eGMCP myeGMCP(ss);




