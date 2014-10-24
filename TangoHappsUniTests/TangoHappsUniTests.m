//
//  TangoHappsUniTests.m
//  TangoHappsUniTests
//
//  Created by Juan Haladjian on 24/10/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Header.h"

#import "THLedEditableObject.h"

@interface TangoHappsUniTests : XCTestCase

@end

@implementation TangoHappsUniTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    THLedEditableObject * led = [[THLedEditableObject alloc] init];
    /*
    XCTAssertFalse(led.on, @"should have been off iniitally!");
    [led turnOn];
    XCTAssertTrue(led.on, @"did not turn on");*/
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
