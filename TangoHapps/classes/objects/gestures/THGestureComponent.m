//
//  THGestureComponent.m
//  TangoHapps
//
//  Created by Timm Beckmann on 06.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGestureComponent.h"
#import "THElementPin.h"

@implementation THGestureComponent

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
    THGestureComponent * copy = [super copyWithZone:zone];
    
    NSMutableArray * pins = [NSMutableArray array];
    for(THElementPin * pin in _pins){
        THElementPin * pincopy = [pin copy];
        //pincopy.hardware = copy;
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
