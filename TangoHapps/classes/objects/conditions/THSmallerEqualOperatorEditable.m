//
//  THSmallerEqualOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THSmallerEqualOperatorEditable.h"
#import "THSmallerEqualOperator.h"

@implementation THSmallerEqualOperatorEditable


-(id) init{
    self = [super init];
    if(self){
        [self loadSmallerEqualOperator];
        self.simulableObject = [[THSmallerEqualOperator alloc] init];
    }
    return self;
}

-(void) loadSmallerEqualOperator{
    
    self.programmingElementType = kProgrammingElementTypeSmallerEqual;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadSmallerEqualOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"SmallerEqual";
}

@end
