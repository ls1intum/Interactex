//
//  THBiggerEqualOperator.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THBiggerEqualOperator.h"

@implementation THBiggerEqualOperator

-(id) init{
    self = [super init];
    if(self){
        
    }
    return self;
}


#pragma mark - Methods

-(BOOL) operate{
    
    self.result = (self.operand1 >= self.operand2);
    return self.result;
}

-(NSString*) description{
    return @"biggerEqual";
}

@end
