//
//  THClientIntegrationTests.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//


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