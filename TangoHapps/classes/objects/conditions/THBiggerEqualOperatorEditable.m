//
//  THBiggerEqualOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THBiggerEqualOperatorEditable.h"
#import "THBiggerEqualOperator.h"

@implementation THBiggerEqualOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadBiggerEqualOperator];
        self.simulableObject = [[THBiggerEqualOperator alloc] init];
    }
    return self;
}

-(void) loadBiggerEqualOperator{
    
    self.programmingElementType = kProgrammingElementTypeBiggerEqual;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadBiggerEqualOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"BiggerEqual";
}

@end
