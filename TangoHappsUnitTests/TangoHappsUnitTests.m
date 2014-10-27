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

#import "THEditor.h"
#import "THProjectViewController.h"
#import "THDirector.h"

#import "THClientProject.h"

@interface TangoHappsUniTests : XCTestCase

@end

@implementation TangoHappsUniTests

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

- (void)testEqualityOfEditablesAndSimulables {
    THProject * testProject = [THTestsHelper emptyProject];
    
    ////
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [testProject addHardwareComponent:led1];
    
    THButtonEditableObject * button1 = [[THButtonEditableObject alloc] init];
    [testProject addHardwareComponent:button1];
    
    [THTestsHelper registerActionForObject:button1 target:led1 event:kEventStartedPressing method:@"turnOn"];
    ////
    
    ////
    /*THLedEditableObject * led2 = [[THLedEditableObject alloc] init];
    [testProject addHardwareComponent:led2];
    
    THTouchPadEditableObject * touchpad2 = [[THTouchPadEditableObject alloc] init];
    [testProject addiPhoneObject:touchpad2];
    
    [THTestsHelper registerActionForObject:touchpad2 target:led2 event:kEventDxChanged method:@"varyIntensity"];
    *////
    
    ////
    THLedEditableObject * led3 = [[THLedEditableObject alloc] init];
    [testProject addHardwareComponent:led3];
    
    THLabelEditableObject * label3 = [[THLabelEditableObject alloc] init];
    [testProject addiPhoneObject:label3];
    
    [THTestsHelper registerActionForObject:led3 target:label3 event:kEventIntensityChanged method:@"setText"];
    ////
    
    ////
    /*THLedEditableObject * led10 = [[THLedEditableObject alloc] init];
    [testProject addHardwareComponent:led10];
    
    THButtonEditableObject * button10 = [[THButtonEditableObject alloc] init];
    [testProject addHardwareComponent:button10];
    
    [THTestsHelper registerActionForObject:button10 target:led10 event:kEventStartedPressing method:@"turnOn"];
    *////
    
    [THTestsHelper startSimulation];
    
    THClientProject * testClientProject = [testProject nonEditableProject];
    
    int numberOfEditableObjects = 0;
    int numberOfSimulableObjects = 0;
    for (int i = 0; i < testProject.allObjects.count; i++) {
        if([[testProject.allObjects objectAtIndex:i] isKindOfClass:[TFEditableObject class]]) {
            numberOfEditableObjects++;
        }
    }
    
    for (int i = 0; i < testClientProject.allObjects.count ; i++) {
        if([[testClientProject.allObjects objectAtIndex:i] isKindOfClass:[TFSimulableObject class]]) {
            numberOfSimulableObjects++;
        }
    }
    
    //XCTAssertFalse(led.on, @"led should be off here");
    //[led turnOn];
    //[button handleTouchBegan];
    //XCTAssertTrue(led.on, @"led should be on here");
    
    //XCTAssertEqual(led2.intensity, 255 , @"led should have default intensity here");
    //touchpad2.dx = -5;
    //XCTAssertEqual(led2.intensity, 250, @"led intensity should be 250 here");
    
    NSLog(@"Edi, Simu : %d = %d", numberOfEditableObjects, numberOfSimulableObjects);
    XCTAssertEqual(numberOfEditableObjects, numberOfSimulableObjects, @"Number of Editable and simulable objects should be equal");
    
}

-(void) testLedIntensity{
    THProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led];
    
    THTouchPadEditableObject * touchpad = [[THTouchPadEditableObject alloc] init];
    [project addiPhoneObject:touchpad];
    
    [THTestsHelper registerActionForObject:touchpad target:led event:kEventDxChanged method:@"varyIntensity"];
    
    [THTestsHelper startSimulation];
    
    XCTAssertEqual(led.intensity, 255 , @"led should have default intensity here");
    touchpad.dx = -5;
    XCTAssertEqual(led.intensity, 250, @"led intensity should be 250 here");
}

/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end

