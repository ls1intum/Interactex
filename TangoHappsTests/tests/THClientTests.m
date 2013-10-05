/*
THClientTests.m
Interactex Designer

Created by Juan Haladjian on 05/11/2012.

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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THLed.h"
#import "THButton.h"
#import "THLilypadEditable.h"
#import "THElementPinEditable.h"
#import "THPinEditable.h"
#import "THLedEditableObject.h"
#import "THPin.h"
#import "THElementPin.h"
#import "THLilyPad.h"
#import "THButtonEditableObject.h"
#import "THLilyPad.h"
#import "THBoardPinEditable.h"

@interface THClientTests : GHTestCase {
}
@end

@implementation THClientTests

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

/*
-(void) testLedPin{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
   
    THLilyPadEditable * lilypad = world.lilypad;
    
    THElementPinEditable * ledpin = [led.pins objectAtIndex:1];
    THBoardPinEditable * lilypadPin = [lilypad digitalPinWithNumber:9];
    [ledpin attachToPin:lilypadPin animated:NO];
    [lilypadPin attachPin:ledpin];
    
    GHAssertTrue(!led.on, @"the led should be off here");
    
    THBoardPin * pin = (THBoardPin*) lilypadPin.object;
    
    pin.currentValue = kDigitalPinValueHigh;
    
    [led updateToPinValue];
    
    GHAssertTrue(led.on, @"the led should be on here");
}

-(void) testElementPinPersistency{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THElementPinEditable * ledpin = [led.pins objectAtIndex:1];
    THBoardPinEditable * boardPin = [world.lilypad digitalPinWithNumber:4];
    [ledpin attachToPin:boardPin animated:NO];
    
    THWorld * neworld = world.nonEditableWorld;
    
    GHAssertNotNil(ledpin.attachedToPin, @"led pin should be attached to something");
    
    world = nil;
    [THWorldController sharedInstance].currentWorld = nil;
    
    THLed * neLed = [neworld.clotheObjects objectAtIndex:0];
    
    THElementPin * ledpin2 = [neLed.pins objectAtIndex:1];
    THElementPin * ledlilypadpin = (THElementPin*) ledpin2.attachedToPin;
    THBoardPin * lilypadpin = [neworld.lilypad digitalPinWithNumber:4];
    
    GHAssertEqualObjects(ledlilypadpin, lilypadpin, @"pin at lilypad and led should be equal");
    
    GHAssertTrue(lilypadpin.attachedPins.count == 1, @"lilypad pin should have a pin attached");
    
    
    GHAssertTrue((lilypadpin.attachedPins.count == 1), @"lilypad pin should have a pin attached");
    
    THElementPin * lilypadledpin = [lilypadpin.attachedPins objectAtIndex:0];
    
    GHAssertEqualObjects(lilypadledpin, ledpin2, @"pin at lilypad should be equal to pin at led");
    
    //[lilypadpin.attachedPins objectAtIndex:0];

}

-(void) testPinHasChanged{
    World * world = [[THWorldController sharedInstance] newWorld];
    THLilyPadEditable * lilypad = [[THLilyPadEditable alloc] init];    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    
    THBoardPinEditable * lilypinEditable = [lilypad digitalPinWithNumber:0];
    THElementPinEditable * ledpinEditable = [led.pins objectAtIndex:1];
    
    [lilypinEditable attachPin:ledpinEditable];    
    [ledpinEditable attachToPin:lilypinEditable animated:NO];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [world addClotheObject:led];
    [world addClotheObject:button];
    
    [THTestsHelper registerObject:button invoke:led method:@"turnOn"];
    
    THBoardPin * lilypin = (THBoardPin*) lilypinEditable.object;
    
    [THTestsHelper startSimulation];
    
    GHAssertFalse(lilypin.hasChanged, @"pin should not have changed here");
    [button handleTouchBegan];
    GHAssertTrue(lilypin.hasChanged, @"pin should have changed here");
    lilypin.hasChanged = NO;
    [button handleTouchBegan];
    GHAssertFalse(lilypin.hasChanged, @"pin should not have changed here");
}

*/

@end
