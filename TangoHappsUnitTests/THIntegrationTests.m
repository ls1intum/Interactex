//
//  TangoHappsUnitTests.m
//  TangoHappsUnitTests
//
//  Created by Nazmus Shaon on 24/10/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ImportHeaders.h"

#import "THTestsHelper.h"

#import "THButtonEditableObject.h"
#import "THLedEditableObject.h"
#import "THTouchPadEditableObject.h"
#import "THLabelEditableObject.h"
#import "THiSwitchEditableObject.h"
#import "THLightSensorEditableObject.h"
#import "THNumberValueEditable.h"

#import "THEditor.h"
#import "THProjectViewController.h"
#import "THDirector.h"

#import "THClientProject.h"
#import "TFEventActionPair.h"

@interface TangoHappsIntegrationTests : XCTestCase

@end

@implementation TangoHappsIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [THTestsHelper startWithEditor];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [THTestsHelper stop];
}

-(void) testLedTurnOn{
    THProject * project = [THTestsHelper emptyProject];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [project addHardwareComponent:button];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led];
    
    [THTestsHelper registerActionForObject:button target:led event:kEventStartedPressing method:kMethodTurnOn];
    
    [THTestsHelper startSimulation];
    
    XCTAssertEqual(led.on, NO , @"led should be off initially");
    [button handleTouchBegan];
    XCTAssertEqual(led.on, YES, @"led should be on here");
}

-(void) testLedIntensity{
    THProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led];
    
    THTouchPadEditableObject * touchpad = [[THTouchPadEditableObject alloc] init];
    [project addiPhoneObject:touchpad];
    
    [THTestsHelper registerActionForObject:touchpad target:led event:kEventDxChanged method:kMethodVaryIntensity];
    
    [THTestsHelper startSimulation];
    
    [led turnOn];
    
    XCTAssertEqual(led.intensity, 255 , @"led should have default intensity here");
    touchpad.dx = -5;
    XCTAssertEqual(led.intensity, 250, @"led intensity should be 250 here");
}

//button sets led intensity with value
-(void) testThirdPartyParameter{
    THProject * project = [THTestsHelper emptyProject];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [project addHardwareComponent:button];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led];
    
    THNumberValueEditable * number = [[THNumberValueEditable alloc] init];
    number.value = 125;
    [project addVisualProgrammingObject:number];
    
    [THTestsHelper registerActionForObject:button target:led event:kEventStartedPressing method:kMethodSetIntensity];
    
    THInvocationConnectionLine * invocationConnection = [project.invocationConnections objectAtIndex:0];
    [THTestsHelper registerPropertyForObject:number connection:invocationConnection property:@"value"];
    
    [THTestsHelper startSimulation];
    
    XCTAssertEqual(led.intensity, 255 , @"led should have default intensity here");
    [button handleTouchBegan];
    XCTAssertEqual(led.intensity, 125, @"led intensity should be 250 here");
}

@end

