//
//  THCopyingTests.m
//  TangoHapps
//
//  Created by Juan Haladjian on 24/02/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "THTestsHelper.h"

#import "THButtonEditableObject.h"
#import "THLedEditableObject.h"
#import "THTouchPadEditableObject.h"
#import "THLabelEditableObject.h"
#import "THiSwitchEditableObject.h"
#import "THLightSensorEditableObject.h"

#import "THEditor.h"
#import "THProjectViewController.h"
#import "THDirector.h"

#import "THClientProject.h"
#import "TFEventActionPair.h"

#import "THElementPinEditable.h"
#import "THSliderEditableObject.h"
#import "THMusicPlayerEditableObject.h"
#import "THiSwitchEditableObject.h"
#import "THTouchPadEditableObject.h"
#import "THImageViewEditable.h"
#import "THContactBookEditable.h"
#import "THMonitorEditable.h"

@interface THCopyingTests : XCTestCase

@end

@implementation THCopyingTests

- (void)setUp {
    [super setUp];
    [THTestsHelper startWithEditor];
}

- (void)tearDown {
    [THTestsHelper stop];
    [super tearDown];
}

-(void) testPinCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led1];
    
    THLedEditableObject * led2 =[led1 copy];
    [led2 addToWorld];
    
    THElementPinEditable * minusPin1 = led1.minusPin;
    THElementPinEditable * minusPin2 = led2.minusPin;
    
    XCTAssertEqual(minusPin1.type, minusPin2.type , @"types dont match");
    XCTAssertEqual(minusPin1.attachedToPin, minusPin2.attachedToPin , @"attachedToPin dont match");
    XCTAssertEqual(minusPin1.connected, minusPin2.connected , @"connected dont match");
    XCTAssertEqual(minusPin2.hardware, led2 , @"hardware dont match");
    XCTAssertTrue([minusPin1.shortDescription isEqualToString:minusPin2.shortDescription] , @"description dont match");
    XCTAssertEqual(minusPin1.defaultBoardPinMode, minusPin2.defaultBoardPinMode , @"defaultBoardPinMode dont match");
}

-(void) testLedCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THLedEditableObject * led1 = [[THLedEditableObject alloc] init];
    [project addHardwareComponent:led1];
    
    led1.intensity = 125;
    led1.onAtStart = YES;
    
    THLedEditableObject * led2 =[led1 copy];
    [led2 addToWorld];
    
    XCTAssertEqual(led1.type, led2.type , @"types dont match");
    XCTAssertEqual(led1.isI2CComponent, led2.isI2CComponent , @"isI2CComponent dont match");
    XCTAssertEqual(led1.onAtStart, led2.onAtStart , @"onAtStart dont match");
    XCTAssertEqual(led1.intensity, led2.intensity , @"intensity dont match");
}

-(void) testViewCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THLabelEditableObject * label1 = [[THLabelEditableObject alloc] init];
    label1.width = 300;
    label1.height = 550;
    label1.backgroundColor = [UIColor blueColor];
    [project addiPhoneObject:label1];
    
    THLabelEditableObject * label2 =[label1 copy];
    [label2 addToWorld];
    
    XCTAssertEqual(label1.width, label2.width , @"width dont match");
    XCTAssertEqual(label1.height, label2.height , @"height dont match");
    XCTAssertEqual(label1.backgroundColor, label2.backgroundColor , @"colors dont match");
    
}

-(void) testLabelCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THLabelEditableObject * label1 = [[THLabelEditableObject alloc] init];
    [project addiPhoneObject:label1];
    
    label1.text = @"hallo";
    label1.numLines = 3;
    
    THLabelEditableObject * label2 =[label1 copy];
    [label2 addToWorld];
    
    XCTAssertTrue([label1.text isEqualToString:label2.text] , @"text dont match");
    XCTAssertEqual(label1.numLines, label2.numLines , @"numLines dont match");
    
}

-(void) testSliderCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THSliderEditableObject * slider1 = [[THSliderEditableObject alloc] init];
    [project addiPhoneObject:slider1];
    
    slider1.value = 125;
    slider1.min = 7;
    slider1.max = 360;
    
    THSliderEditableObject * slider2 = [slider1 copy];
    [slider2 addToWorld];
    
    XCTAssertEqual(slider1.value, slider2.value , @"value doesnt match");
    XCTAssertEqual(slider1.min, slider2.min , @"min doesnt match");
    XCTAssertEqual(slider1.max, slider2.max , @"max doesnt match");
}

-(void) testMusicPlayerCopy{
    
    THProject * project = [THTestsHelper emptyProject];
    THSliderEditableObject * slider1 = [[THSliderEditableObject alloc] init];
    [project addiPhoneObject:slider1];
    
    slider1.value = 125;
    slider1.min = 7;
    slider1.max = 360;
    
    THSliderEditableObject * slider2 = [slider1 copy];
    [slider2 addToWorld];
    
    XCTAssertEqual(slider1.value, slider2.value , @"value doesnt match");
    XCTAssertEqual(slider1.min, slider2.min , @"min doesnt match");
    XCTAssertEqual(slider1.max, slider2.max , @"max doesnt match");
}


@end
