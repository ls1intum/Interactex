//
//  THClientTests.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/22/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

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
