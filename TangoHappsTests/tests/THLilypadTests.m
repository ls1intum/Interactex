/*
THLilypadTests.m
Interactex Designer

Created by Juan Haladjian on 14/11/2012.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THLilypadEditable.h"
#import "THLedEditableObject.h"
#import "THBoardPinEditable.h"
#import "THElementPinEditable.h"
#import "THBoardPin.h"
#import "THButton.h"
#import "THButtonEditableObject.h"
#import "THBuzzerEditableObject.h"
#import "THResistorExtension.h"

@interface THLilypadTests : GHTestCase

@end

@implementation THLilypadTests

//this runs once before all tests
-(void) setUpClass{
    [THTestsHelper startCocos2d];
}

//this runs once after all tests
-(void) tearDownClass{
    
}

//this is called before each test
-(void) setUp{
    
}

//this is called after each test
-(void) tearDown{
    
}


-(void) testObjectRemoved{
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    
    World * world = [[THWorldController sharedInstance] newWorld];
    [world addClotheObject:led];
    
    THBoardPinEditable * boardPin = [world.lilypad digitalPinWithNumber:3];
    THElementPinEditable * ledDigitalPin = led.digitalPin;
    
    [ledDigitalPin attachToPin:boardPin animated:NO];
    [boardPin attachPin:ledDigitalPin];
    
    GHAssertEquals(ledDigitalPin.connections.count, (NSUInteger) 1, @"led pin should have one connection");
    GHAssertEquals(boardPin.attachedPins.count, (NSUInteger) 1, @"Board Pin should have an attached pin");
    GHAssertEquals(((THBoardPin*)boardPin.object).attachedPins.count, (NSUInteger) 1, @"board pin should have an attached pin");
    
    [led removeFromWorld];
    
    GHAssertEquals(boardPin.connections.count, (NSUInteger) 0, @"board pin should have no connections here");
    GHAssertEquals(boardPin.attachedPins.count, (NSUInteger) 0, @"Board Pin should have no attached pins");
    
    GHAssertEquals(((THBoardPin*)boardPin.object).attachedPins.count, (NSUInteger) 0, @"board pin should have no attached pins");
}

-(void) testExtensionAndPinAreEqual{
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    
    World * world = [[THWorldController sharedInstance] newWorld];
    [world addClotheObject:button];
    
    THResistorExtension * extension = [button.extensions objectAtIndex:0];
    GHAssertEquals(extension.pin, button.digitalPin, @"extension pin and pin should be the same");    
    
}

-(void) testPinRepositioned{
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    
    World * world = [[THWorldController sharedInstance] newWorld];
    [world addClotheObject:led];
    
    THBoardPinEditable * boardPin3 = [world.lilypad digitalPinWithNumber:3];
    THBoardPinEditable * boardPin4 = [world.lilypad digitalPinWithNumber:4];
    THElementPinEditable * ledPin = led.digitalPin;
    
    //place led on pin 3
    [ledPin attachToPin:boardPin3 animated:NO];
    [boardPin3 attachPin:ledPin];
    
    //change led to pin 4
    [ledPin attachToPin:boardPin4 animated:NO];
    [boardPin4 attachPin:ledPin];
    
    GHAssertEquals(boardPin3.attachedPins.count, (NSUInteger) 0, @"board pin 3 should have nothing");
    GHAssertEquals(boardPin4.attachedPins.count, (NSUInteger) 1, @"board pin 4 should have a pin");
}


-(void) testPinReplaced{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    THLedEditableObject * led2 = [[THLedEditableObject alloc] init];
    
    [world addClotheObject:led1];
    [world addClotheObject:led2];
    
    THBoardPinEditable * boardPin3 = [world.lilypad digitalPinWithNumber:3];
    THElementPinEditable * led1Pin = led1.digitalPin;
    THElementPinEditable * led2Pin = led2.digitalPin;
    
    //place led1 on pin 3
    [led1Pin attachToPin:boardPin3 animated:NO];
    [boardPin3 attachPin:led1Pin];
    
    //place led2 on same pin
    [led2Pin attachToPin:boardPin3 animated:NO];
    [boardPin3 attachPin:led2Pin];
    
    GHAssertEquals(boardPin3.attachedPins.count, (NSUInteger) 1, @"board pin 3 should have one pin");
    GHAssertEquals([boardPin3.attachedPins objectAtIndex:0], led2Pin, @"board pin 3 should have led2 pin");
    
    GHAssertNil(led1Pin.attachedToPin, @"led1's pin should not be attached anymore");
    GHAssertEquals(led2Pin.attachedToPin, boardPin3, @"led2's pin should be attached to the lilypad");
}

-(void) testLilypadPins{
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];
    
    THBoardPinEditable * pin0 = [lilypad digitalPinWithNumber:0];
    GHAssertEquals(pin0.type, kPintypeDigital, @"pin 0 should be digital");
    
    THBoardPinEditable * pin5 = [lilypad.pins objectAtIndex:5];
    GHAssertEquals(pin5.type, kPintypeMinus, @"pin 5 should be minus");
    
    THBoardPinEditable * pin6 = [lilypad.pins objectAtIndex:6];
    GHAssertEquals(pin6.type, kPintypePlus, @"pin 6 should be minus");
}

-(void) testLedDefaultMode{
    
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];
    
    THBoardPinEditable * pin0 = [lilypad digitalPinWithNumber:0];
    GHAssertEquals(pin0.mode, kPinModeUndefined, @"pin mode should be undefined here");
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    THElementPinEditable * pin = [led.pins objectAtIndex:1];
    
    [pin0 attachPin:pin];
        
    GHAssertEquals(pin0.mode, kPinModeDigitalOutput, @"pin mode should be digital output here");
}

-(void) testBuzzerDefaultMode{
    
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];
    
    THBoardPinEditable * pin0 = [lilypad digitalPinWithNumber:0];
    GHAssertEquals(pin0.mode, kPinModeUndefined, @"pin mode should be undefined here");
    
    THBuzzerEditableObject * buzzer = [[THBuzzerEditableObject alloc] init];
    THElementPinEditable * pin = buzzer.digitalPin;
    
    [pin0 attachPin:pin];
    
    GHAssertEquals(pin0.mode, kPinModeBuzzer, @"pin mode should be buzzer here");
}

-(void) testButtonDefaultMode{
    
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];
    
    THBoardPinEditable * pin0 = [lilypad digitalPinWithNumber:0];
    GHAssertEquals(pin0.mode, kPinModeUndefined, @"pin mode should be undefined here");
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    THElementPinEditable * pin = [button.pins objectAtIndex:1];
    
    [pin0 attachPin:pin];
    
    GHAssertEquals(pin0.mode, kPinModeDigitalInput, @"pin mode should be buzzer here");
}

@end
