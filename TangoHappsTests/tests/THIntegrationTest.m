//
//  THSimulationTest.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/28/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLedEditableObject.h"
#import "THButtonEditableObject.h"
#import "THLabelEditableObject.h"
#import "THiPhoneEditableObject.h"
#import "THButton.h"

@interface THIntegrationTest : GHTestCase {
}
@end

@implementation THIntegrationTest

//this runs once before all tests
-(void) setUpClass{
    [THTestsHelper startWithEditor];
}

//this runs once after all tests
-(void) tearDownClass{
    
    [THTestsHelper stop];
}

//this is called before each test
-(void) setUp{
    
}

//this is called after each test
-(void) tearDown{
    
}

-(void) testLedOn{

    THCustomProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addClotheObject:led];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [project addClotheObject:button];
    
    [THTestsHelper registerActionForObject:button target:led event:kEventStartedPressing method:@"turnOn"];
    
    [THTestsHelper startSimulation];
    
    GHAssertFalse(led.on, @"led should be off here");
    [button handleTouchBegan];
    GHAssertTrue(led.on, @"led should be on here");
}

-(void) testLedIntensity{
    THCustomProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addClotheObject:led];
    
    THTouchPadEditableObject * touchpad = [[THTouchPadEditableObject alloc] init];
    [project addiPhoneObject:touchpad];
       
    [THTestsHelper registerActionForObject:touchpad target:led event:kEventDxChanged method:@"varyIntensity"];
    
    [THTestsHelper startSimulation];
        
    GHAssertEquals(led.intensity, 255 , @"led should have default intensity here");
    touchpad.dx = -5;
    GHAssertEquals(led.intensity, 250, @"led intensity should be 250 here");
}

-(void) testLabelText{
    
    THCustomProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addClotheObject:led];
    
    THLabelEditableObject * label = [[THLabelEditableObject alloc] init];
    [project addiPhoneObject:label];
    
    [THTestsHelper registerActionForObject:led target:label event:kEventIntensityChanged method:@"setText"];
    
    [THTestsHelper startSimulation];
    
    GHAssertEqualStrings(label.text, @"255", @"label text should be default intensity");
    led.intensity = 10;
    GHAssertEqualStrings(label.text, @"10", @"label text should be 10 one here");
}

-(void) testComparisonCondition{
    THCustomProject * project = [THTestsHelper emptyProject];
    
    THBuzzerEditableObject * buzzer1 = [[THBuzzerEditableObject alloc] init];
    buzzer1.frequency = 1000;
    [project addClotheObject:buzzer1];
    
    THBuzzerEditableObject * buzzer2 = [[THBuzzerEditableObject alloc] init];
    buzzer2.frequency = 2000;
    [project addClotheObject:buzzer2];
    
    THComparisonConditionEditable * condition = [[THComparisonConditionEditable alloc] init];
    condition.type = kConditionTypeBiggerThan;
    [project addCondition:condition];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addClotheObject:led];
    
    [THTestsHelper registerActionForObject:buzzer1 target:condition event:kEventFrequencyChanged method:kMethodSetValue1];
    [THTestsHelper registerActionForObject:buzzer2 target:condition event:kEventFrequencyChanged method:kMethodSetValue2];
    [THTestsHelper registerActionForObject:condition target:led event:kEventConditionIsTrue method:kMethodTurnOn];
            
    [THTestsHelper startSimulation];
    
    GHAssertTrue(!led.on, @"led should be off now");
    buzzer1.frequency = 3000;
    GHAssertTrue(led.on, @"led should be on now");
}

-(void) testGrouperCondition{
    THCustomProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [project addClotheObject:led1];
    
    THLedEditableObject * led2 = [[THLedEditableObject alloc] init];
    [project addClotheObject:led2];
    
    THGrouperConditionEditable * condition = [[THGrouperConditionEditable alloc] init];
    [project addCondition:condition];
    
    THLedEditableObject * led3 = [[THLedEditableObject alloc] init];
    [project addClotheObject:led3];
    
    [THTestsHelper registerActionForObject:led1 target:condition event:kEventOnChanged method:kMethodSetValue1];
    [THTestsHelper registerActionForObject:led2 target:condition event:kEventOnChanged method:kMethodSetValue2];
    [THTestsHelper registerActionForObject:condition target:led3 event:kEventConditionIsTrue method:kMethodTurnOn];
            
    [THTestsHelper startSimulation];
        
    GHAssertFalse(led3.on, @"led3 should be off");
    [led1 turnOn];
    GHAssertFalse(led3.on, @"led3 should be still off");
    [led2 turnOn];
    GHAssertTrue(led3.on, @"led3 should be on now");
}


@end