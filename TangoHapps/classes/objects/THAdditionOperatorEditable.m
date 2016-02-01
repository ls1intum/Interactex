//
//  THAdditionOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THAdditionOperatorEditable.h"
#import "THAdditionOperator.h"

@implementation THAdditionOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadAdditionOperator];
        self.simulableObject = [[THAdditionOperator alloc] init];
    }
    return self;
}

-(void) loadAdditionOperator{
    
    self.programmingElementType = kProgrammingElementTypeAddition;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadAdditionOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THAdditionOperatorEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

-(NSString*) description{
    return @"Addition";
}

@end
