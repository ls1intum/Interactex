//
//  THOrOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 04/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THOrOperatorEditable.h"
#import "THOrOperator.h"

@implementation THOrOperatorEditable

-(id) init{
    self = [super init];
    if(self){
        [self loadOrOperator];
        self.simulableObject = [[THOrOperator alloc] init];
    }
    return self;
}

-(void) loadOrOperator{
    
    self.programmingElementType = kProgrammingElementTypeOr;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadOrOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"Or";
}

@end
