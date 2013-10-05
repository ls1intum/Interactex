//
//  THTimer.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTimer.h"

@implementation THTimer

-(id) init {
    self = [super init];
    if(self){
        _frequency = 1.0f;
        
        [self loadTimer];
    }
    return self;
}

-(void) loadTimer {
    
    TFMethod * method1 = [TFMethod methodWithName:@"start"];
    TFMethod * method2 = [TFMethod methodWithName:@"stop"];
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _frequency = [decoder decodeDoubleForKey:@"frequency"];
        _type = [decoder decodeIntegerForKey:@"type"];
        
        [self loadTimer];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeDouble:_frequency forKey:@"frequency"];
    [coder encodeInteger:_type forKey:@"type"];
}

-(id)copyWithZone:(NSZone *)zone {
    THTimer * copy = [super copyWithZone:zone];
    
    copy.frequency = self.frequency;
    copy.type = self.type;
    
    return copy;
}

#pragma mark - Methods

-(void) start{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_frequency target:self selector:@selector(triggerActions) userInfo:nil repeats:(self.type == kTimerTypeAlways)];
}

-(void) stop{
    
    [_timer invalidate];
    
    _timer = nil;
}

-(void) triggerActions{
    
    [self triggerEventNamed:kEventTriggered];
}

-(void) prepareToDie{
    
    [super prepareToDie];
}

-(NSString*) description{
    return @"timer";
}


@end
