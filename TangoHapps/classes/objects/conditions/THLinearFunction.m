//
//  THLinearFunction.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLinearFunction.h"

@implementation THLinearFunction

#pragma mark - Init

+(id) functionWithA:(float) a b:(float) b{
    return [[THLinearFunction alloc] initWithA:a b:b];
}

-(id) initWithA:(float) a b:(float) b{
    self = [super init];
    if(self){
        _a = a;
        _b = b;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if(self) {
        _a = [decoder decodeFloatForKey:@"a"];
        _b = [decoder decodeFloatForKey:@"b"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeFloat:_a forKey:@"a"];
    [coder encodeFloat:_b forKey:@"b"];
}

-(id)copyWithZone:(NSZone *)zone {
    THLinearFunction * copy = [[THLinearFunction alloc] init];
    
    copy.a = self.a;
    copy.b = self.b;
    
    return copy;
}

#pragma mark - Methods

-(float) evaluate:(float) x{
    return self.a * x + self.b;
}

@end
