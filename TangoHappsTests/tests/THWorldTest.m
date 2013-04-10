//
//  THClientTest.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

@interface THWorldTest : GHTestCase {
    
}
@end

@implementation THWorldTest

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


-(void) testLedPinsCleaned{
    World * world = [[THWorldController sharedInstance] newWorld];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [world addClotheObject:led];
    
    THElementPinEditable * digitalPin = led.digitalPin;
    THElementPinEditable * minusPin = led.minusPin;
    
    THLilyPadEditable * lilypad = world.lilypad;
    THBoardPinEditable * pin9 = [lilypad digitalPinWithNumber:9];
    THBoardPinEditable * minusPinLilypad = lilypad.minusPin;
    
    [pin9 attachPin:digitalPin];
    [digitalPin attachToPin:pin9 animated:NO];
    
    [minusPinLilypad attachPin:minusPin];
    [minusPin attachToPin:minusPinLilypad animated:NO];
    
    THWorld * neworld = world.nonEditableWorld;
    THLed * realLed = [neworld.clotheObjects objectAtIndex:0];
    THLilyPad * realLilypad = neworld.lilypad;
    
    THElementPin * realLedPinDigital = realLed.digitalPin;
    THElementPin * realLedPinMinus = realLed.minusPin;
    THBoardPin * realBoardPin9 = [realLilypad digitalPinWithNumber:9];
    THBoardPin * realBoardPinMinus = realLilypad.minusPin;
    
    GHAssertEquals(realLedPinDigital.attachedToPin, realBoardPin9, @"led digital pin should be attached to lilypad pin 9");
    GHAssertEquals(realLedPinMinus.attachedToPin, realBoardPinMinus, @"led minus pin should be attached to lilypad minus pin");
}

@end