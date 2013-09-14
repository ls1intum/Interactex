//
//  THSensor.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THHardwareComponent.h"
#import "THElementPin.h"

@implementation THHardwareComponent

-(id) init{
    self = [super init];
    if(self){
        _pins = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self) {
        _pins = [decoder decodeObjectForKey:@"pins"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_pins forKey:@"pins"];
}

-(id)copyWithZone:(NSZone *)zone {
    THHardwareComponent * copy = [super copyWithZone:zone];
    
    NSMutableArray * pins = [NSMutableArray array];
    for(THElementPin * pin in _pins){
        THElementPin * pincopy = [pin copy];
        pincopy.hardware = copy;
        [pins addObject:pincopy];
    }
    copy.pins = pins;
    
    return copy;
}

#pragma mark - Methods

-(void) handlePin:(THPin*) pin changedValueTo:(NSInteger) newValue{
    NSLog(@"warning, not handling pin changedValueTo on %@",self);
}

-(void) prepareToDie{
    self.pins = nil;
    [super prepareToDie];
}

@end
