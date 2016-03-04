//
//  THEqualOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THEqualOperatorEditable.h"
#import "THEqualOperator.h"

@implementation THEqualOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadEqualOperator];
        self.simulableObject = [[THEqualOperator alloc] init];
    }
    return self;
}

-(void) loadEqualOperator{
    
    self.programmingElementType = kProgrammingElementTypeEqual;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadEqualOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"Equal";
}


@end
