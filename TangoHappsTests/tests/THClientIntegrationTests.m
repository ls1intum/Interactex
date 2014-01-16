/*
THClientIntegrationTests.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

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

#import <Foundation/Foundation.h>

@interface THClientIntegrationTests : GHTestCase

@end

@implementation THClientIntegrationTests

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

-(void) testLedOn{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [world addClotheObject:button];
    
    [THTestsHelper registerActionForObject:button target:led event:kEventStartedPressing method:@"turnOn"];
    
    THWorld * thWorld = [THTestsHelper startClientSimulation];
    world = nil;
    
    THLed * neLed = [thWorld.clotheObjects objectAtIndex:0];
    THButton * neButton = [thWorld.clotheObjects objectAtIndex:1];

    GHAssertFalse(neLed.on, @"led should be off here");
    [neButton handleStartedPressing];
    GHAssertTrue(neLed.on, @"led should be on here");
}

-(void) testLedIntensity{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THTouchPadEditableObject * touchpad = [[THTouchPadEditableObject alloc] init];
    [world addiPhoneObject:touchpad];
    
    [THTestsHelper registerActionForObject:touchpad target:led event:kEventDxChanged method:@"varyIntensity"];
    
    THWorld * thWorld = [THTestsHelper startClientSimulation];
    world = nil;
    
    THLed * neLed = [thWorld.clotheObjects objectAtIndex:0];
    THTouchpad * neTouchpad = [thWorld.iPhoneObjects objectAtIndex:0];
    
    GHAssertEquals(neLed.intensity, 255 , @"led should have default intensity here");
    neTouchpad.dx = -5;
    GHAssertEquals(neLed.intensity, 250, @"led intensity should be 250 here");
}

-(void) testLabelText{
    
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THLabelEditableObject * label = [[THLabelEditableObject alloc] init];
    [world addiPhoneObject:label];
    
    [THTestsHelper registerActionForObject:led target:label event:kEventIntensityChanged method:@"setText"];
    
    THWorld * thWorld = [THTestsHelper startClientSimulation];
    world = nil;
    
    THLed * neLed = [thWorld.clotheObjects objectAtIndex:0];
    THLabel * neLabel = [thWorld.iPhoneObjects objectAtIndex:0];
    
    
    GHAssertEqualStrings(neLabel.text, @"255", @"label text should be default intensity here");
    neLed.intensity = 10;
    GHAssertEqualStrings(neLabel.text, @"10", @"label text should be 10 one here");
}

-(void) testComparisonCondition{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THBuzzerEditableObject * buzzer1 = [[THBuzzerEditableObject alloc] init];
    ((THBuzzer*)buzzer1.object).frequency = 1000;
    [world addClotheObject:buzzer1];
    
    THBuzzerEditableObject * buzzer2 = [[THBuzzerEditableObject alloc] init];
    ((THBuzzer*)buzzer2.object).frequency = 2000;
    [world addClotheObject:buzzer2];
    
    THComparisonConditionEditable * condition = [[THComparisonConditionEditable alloc] init];
    ((THComparisonCondition*)condition.object).type = kConditionTypeBiggerThan;
    [world addCondition:condition];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    [THTestsHelper registerActionForObject:buzzer1 target:condition event:kEventFrequencyChanged method:kMethodSetValue1];
    [THTestsHelper registerActionForObject:buzzer2 target:condition event:kEventFrequencyChanged method:kMethodSetValue2];
    [THTestsHelper registerActionForObject:condition target:led event:kEventConditionIsTrue method:kMethodTurnOn];
    
    THWorld * thWorld = [THTestsHelper startClientSimulation];
    world = nil;
    
    THBuzzer * realBuzzer1 = [thWorld.clotheObjects objectAtIndex:0];
    
    THLed * realLed = [thWorld.clotheObjects objectAtIndex:2];
    
    GHAssertTrue(!realLed.on, @"led2 should be off now");
    realBuzzer1.frequency = 3000;
    GHAssertTrue(realLed.on, @"led2 should be on now");
}

-(void) testGrouperCondition{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led1];
    
    THLedEditableObject * led2 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led2];
    
    THGrouperConditionEditable * condition = [[THGrouperConditionEditable alloc] init];
    [world addCondition:condition];
    
    THLedEditableObject * led3 = [[THLedEditableObject alloc] init];
    [world addClotheObject:led3];
    
    [THTestsHelper registerActionForObject:led1 target:condition event:kEventOnChanged method:kMethodSetValue1];
    [THTestsHelper registerActionForObject:led2 target:condition event:kEventOnChanged method:kMethodSetValue2];
    [THTestsHelper registerActionForObject:condition target:led3 event:kEventConditionIsTrue method:kMethodTurnOn];
    
    THWorld * thWorld = [THTestsHelper startClientSimulation];
    world = nil;
    
    THLed * realLed1 = [thWorld.clotheObjects objectAtIndex:0];
    THLed * realLed2 = [thWorld.clotheObjects objectAtIndex:1];
    THLed * realLed3 = [thWorld.clotheObjects objectAtIndex:2];
    
    GHAssertTrue(!realLed3.on, @"led3 should be off");
    [realLed1 turnOn];
    GHAssertTrue(!realLed3.on, @"led3 should be still off");
    [realLed2 turnOn];
    GHAssertTrue(realLed3.on, @"led3 should be on now");
}


@end