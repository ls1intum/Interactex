//
//  THAndOperatorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 04/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THAndOperatorEditable.h"
#import "THAndOperator.h"

@implementation THAndOperatorEditable


-(id) init{
    self = [super init];
    if(self){
        [self loadAndOperator];
        self.simulableObject = [[THAndOperator alloc] init];
    }
    return self;
}

-(void) loadAndOperator{
    
    self.programmingElementType = kProgrammingElementTypeAnd;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self) {
        [self loadAndOperator];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(NSString*) description{
    return @"And";
}


@end
