
#include "ble_Mini.h"

void BLEMini_begin(unsigned long bound)
{
		Serial.begin(bound);
}

int BLEMini_available()
{
		return Serial.available();
}

void BLEMini_write(unsigned char dat)
{
		Serial.write(dat);
}

void BLEMini_write_bytes(unsigned char *dat, unsigned char len)
{
		delay(10);
		if(len > 0)
			Serial.write(dat, len);
}

int BLEMini_read()
{
	delay(10);	
	return Serial.read();
}
