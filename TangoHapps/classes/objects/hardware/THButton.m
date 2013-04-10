//
//  THButton.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THButton.h"
#import "THElementPin.h"
#import "THPin.h"

@implementation THButton

-(void) load{

    TFEvent * event1 = [TFEvent eventNamed:kEventStartedPressing];
    TFEvent * event2 = [TFEvent eventNamed:kEventStoppedPressing];
    self.events = [NSMutableArray arrayWithObjects:event1, event2, nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone
{
    THButton * copy = [super copyWithZone:zone];
    
    return copy;
}


#pragma mark - Methods

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    
    if(!self.isDown && pin.currentValue == kDigitalPinValueHigh){
        [self handleStartedPressing];
    } else if(self.isDown && pin.currentValue == kDigitalPinValueLow){
        [self handleStoppedPressing];
    }
}

-(void) handleStartedPressing{
    self.isDown = YES;
    
    [self triggerEventNamed:kEventStartedPressing];
}

-(void) handleStoppedPressing{
    self.isDown = NO;
    
    [self triggerEventNamed:kEventStoppedPressing];
}

-(NSString*) description{
    return @"button";
}

@end
