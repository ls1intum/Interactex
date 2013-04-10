//
//  THCustomSimulator.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/29/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THCustomSimulator.h"
#import "THiPhoneEditableObject.h"
#import "THiPhone.h"

#import "THPinValue.h"
#import "THBoardPinEditable.h"
#import "THLilypadEditable.h"
#import "THBoardPin.h"

#import "THPinsController.h"
#import "THPinsControllerContainer.h"

@implementation THCustomSimulator

-(void) addObjects{
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    if(project.iPhone != nil){
        [project.iPhone addToLayer:self];
    }
    for (TFEditableObject * object in project.allObjects) {
        [object addToLayer:self];
    }
}

-(void) removeObjects{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    if(project.iPhone != nil){
        [project.iPhone removeFromLayer:self];
    }
    
    [self removeAllChildrenWithCleanup:YES];
}

#pragma mark - PinsController

-(void) addPinsController{
    CGSize const kPinsControllerSize = {330, kPinsControllerMinHeight};
    
    CGRect frame = CGRectMake(690,310,kPinsControllerSize.width,kPinsControllerSize.height);
    _pinsController = [[THPinsController alloc] initWithFrame:frame];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:_pinsController];
    
    _state = kSimulatorStatePins;
}

-(void) removePinsController{
    if(_pinsController != nil) {
        [_pinsController prepareToDie];
        [_pinsController removeFromSuperview];
        _pinsController = nil;
    }
    _state = kSimulatorStateNormal;
}

#pragma mark - Client

-(void) updateLilypadPinsWithPins:(NSMutableArray*) pins{
    //NSLog(@"%@", [pins objectAtIndex:0]);
    
    THCustomProject * world = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    THLilyPadEditable * lilypad = world.lilypad;
    for (THPinValue * pin in pins) {
        THBoardPinEditable * editablePin;
        if(pin.type == kPintypeDigital) {
            editablePin = [lilypad digitalPinWithNumber:pin.number];
        } else if(pin.type == kPintypeAnalog){
            editablePin = [lilypad analogPinWithNumber:pin.number];
        }
        
        THBoardPin * lilypadPin = (THBoardPin*) editablePin.simulableObject;
        lilypadPin.currentValue = pin.value;
    }
}

-(void) willAppear{
    [super willAppear];
    [self addObjects];
}

-(void) willDisappear{
    [super willDisappear];
    [self removeObjects];
    [self removePinsController];
}

@end
