//
//  THTimerEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTimerEditable.h"
#import "THTimer.h"
#import "THTimerProperties.h"

@implementation THTimerEditable

-(void) loadTimer{
    self.sprite = [CCSprite spriteWithFile:@"timer.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THTimer alloc] init];
        
        [self loadTimer];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadTimer];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THTimerEditable * copy = [super copyWithZone:zone];
    
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THTimerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) start{
    THTimer * timer = (THTimer*) self.simulableObject;
    [timer start];
}

-(void) stop{
    THTimer * timer = (THTimer*) self.simulableObject;
    [timer stop];
}

-(void) update{
    
}

-(float) frequency{
    THTimer * timer = (THTimer*) self.simulableObject;
    return timer.frequency;
}

-(void) setFrequency:(float)frequency{
    THTimer * timer = (THTimer*) self.simulableObject;
    timer.frequency = frequency;
}

-(THTimerType) type{
    THTimer * timer = (THTimer*) self.simulableObject;
    return timer.type;
}

-(void) setType:(THTimerType)type{
    THTimer * timer = (THTimer*) self.simulableObject;
    timer.type = type;
}

-(NSString*) description{
    return @"Timer";
}

@end
