//
//  THSwitch.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSlideSwitch.h"
#import "THElementPin.h"

@implementation THSlideSwitch

-(void) load{
    
    TFEvent * event1 = [TFEvent eventNamed:kNotificationSwitchOn];
    TFEvent * event2 = [TFEvent eventNamed:kNotificationSwitchOff];
    
    self.events = [NSMutableArray arrayWithObjects:event1, event2,nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THSlideSwitch * copy = [super copyWithZone:zone];
    copy.on = self.on;
    
    return copy;
}

#pragma mark - Methods

-(void) handlePin:(THBoardPin*) pin changedValueTo:(NSInteger) newValue{
    
    if(!self.on && pin.value == kDigitalPinValueHigh){
        [self switchOn];
    } else if(self.on && pin.value == kDigitalPinValueLow){
        [self switchOff];
    }
}

-(void) switchOn{
    self.on = YES;
    [self triggerEventNamed:kNotificationSwitchOn];
}

-(void) switchOff{
    self.on = NO;
    [self triggerEventNamed:kNotificationSwitchOff];
}

-(void) toggle{
    if(self.on){
        [self switchOff];
    } else {
        [self switchOn];
    }
}

-(NSString*) description{
    return @"button";
}

@end
