//
//  THDivisionOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 31/01/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THDivisionOperatorEditable.h"
#import "THDivisionOperator.h"

@implementation THDivisionOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadDivisionOperator];
        self.simulableObject = [[THDivisionOperator alloc] init];
    }
    return self;
}

-(void) loadDivisionOperator{
    
    self.programmingElementType = kProgrammingElementTypeDivision;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadDivisionOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THDivisionOperatorEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

-(NSString*) description{
    return @"Division";
}

@end
