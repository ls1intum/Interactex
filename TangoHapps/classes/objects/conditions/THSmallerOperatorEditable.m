//
//  THSmallerOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSmallerOperatorEditable.h"
#import "THSmallerOperator.h"

@implementation THSmallerOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadSmallerOperator];
        self.simulableObject = [[THSmallerOperator alloc] init];
    }
    return self;
}

-(void) loadSmallerOperator{
    
    self.programmingElementType = kProgrammingElementTypeSmaller;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadSmallerOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"Smaller";
}

@end
