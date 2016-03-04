//
//  THBiggerOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THBiggerOperatorEditable.h"
#import "THBiggerOperator.h"

@implementation THBiggerOperatorEditable


-(id) init{
    self = [super init];
    if(self){
        [self loadBiggerOperator];
        self.simulableObject = [[THBiggerOperator alloc] init];
    }
    return self;
}

-(void) loadBiggerOperator{
    
    self.programmingElementType = kProgrammingElementTypeBigger;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadBiggerOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"Bigger";
}

@end
