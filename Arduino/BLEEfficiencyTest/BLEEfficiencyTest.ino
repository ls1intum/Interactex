/*
BleDemo.ino

Interactex

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and
connect e-Textile hardware with smartphone functionality. Interactex Client
is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the
Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:

juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

The first version of the software was designed and implemented as part
of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was
founded by Telekom Innovation Laboratories Berlin. It has been extended with
funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS
developed by Gabriel Handford) and cocos2D libraries (a framework for building
2D games and graphical applications developed by Zynga Inc.). 

www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library
is based on the original Arduino Firmata library.

www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind
permission from Fritzing. Fritzing is an open-source hardware initiative to
support designers, artists, researchers and hobbyists to work creatively with
interactive electronics.

www.frizting.org

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "SoftwareSerial.h"

unsigned long currentMillis;        // store the current value from millis()
unsigned long previousMillis;       // for comparison with currentMillis
long interval = 100; 

boolean shouldSend;
byte nextVal = 100;

SoftwareSerial ss(2,3);

void setup() 
{
  Serial.begin(9600);
  ss.begin(19200);
  
  shouldSend = 0;
}

void loop() 
{
  unsigned long currentMillis = millis();

  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis; 
    
  byte pin, analogPin;

  while(ss.available()){
    byte val = ss.read();
          
    if(val != nextVal){
      int valInt = val;
      Serial.print(valInt);
      Serial.print( " next is: ");
      int nextValInt = nextVal;
       Serial.println(nextValInt);
    }
   

    nextVal = val + 1;
    if(nextVal == 116){//the iOS side sends [100 ... 116]
      nextVal = 100;
    }
  }
  
    for(int j = 100 ; j < 116 ; j++){
      ss.write(j);
    }
  }
 
}
