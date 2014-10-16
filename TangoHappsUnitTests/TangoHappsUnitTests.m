//
//  TangoHappsUnitTests.m
//  TangoHappsUnitTests
//
//  Created by Nazmus Shaon on 16/10/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

// Cannot import the following libraries. Problem might be in Target dependencies and Linking of libraries
/*
 #import "THTestsHelper.h"
 #import "THLedEditableObject.h"
 #import "THButtonEditableObject.h"
 #import "THLabelEditableObject.h"
 #import "THiPhoneEditableObject.h"
 #import "THButton.h"
 
 */

@interface TangoHappsUnitTests : XCTestCase

@end

@implementation TangoHappsUnitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
-(void) testLedOn{
    
    THProject * project = [THTestsHelper emptyProject];
    
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led];
    
    THButtonEditableObject * button = [[THButtonEditableObject alloc] init];
    [project addHardwareComponent:button];
    
    [THTestsHelper registerActionForObject:button target:led event:kEventStartedPressing method:@"turnOn"];
    
    [THTestsHelper startSimulation];
    
    GHAssertFalse(led.on, @"led should be off here");
    [button handleTouchBegan];
    GHAssertTrue(led.on, @"led should be on here");
}
*/

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
