//
//  THMultiplicationOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THMultiplicationOperatorEditable.h"
#import "THMultiplicationOperator.h"

@implementation THMultiplicationOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadMultiplicationOperator];
        self.simulableObject = [[THMultiplicationOperator alloc] init];
    }
    return self;
}

-(void) loadMultiplicationOperator{
    
    self.programmingElementType = kProgrammingElementTypeMultiplication;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadMultiplicationOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THMultiplicationOperatorEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

-(NSString*) description{
    return @"Multiplication";
}

@end
