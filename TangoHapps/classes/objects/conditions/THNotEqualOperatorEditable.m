//
//  THNotEqualOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THNotEqualOperatorEditable.h"
#import "THNotEqualOperator.h"

@implementation THNotEqualOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadNotEqualOperator];
        self.simulableObject = [[THNotEqualOperator alloc] init];
    }
    return self;
}

-(void) loadNotEqualOperator{
    
    self.programmingElementType = kProgrammingElementTypeNotEqual;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadNotEqualOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"NotEqual";
}

@end
