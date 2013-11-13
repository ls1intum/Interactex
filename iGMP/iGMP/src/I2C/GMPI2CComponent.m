//
//  IFI2CComponent.m
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPI2CComponent.h"
#import "GMPI2CRegister.h"

@implementation GMPI2CComponent

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    //[aCoder encodeInt:self.address forKey:@"address"];
    [aCoder encodeObject:self.registers forKey:@"registers"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeIntegerForKey:@"address"];
        self.registers = [aDecoder decodeObjectForKey:@"registers"];
    }
    return self;
}

#pragma mark - Methods

-(id) init{
    self = [super init];
    if(self){
        self.registers = [NSMutableArray array];
    }
    return self;
}

-(void) addRegister:(GMPI2CRegister*) reg{
    
    [self.registers addObject:reg];
}

-(void) removeRegister:(GMPI2CRegister *)reg{
   [self.registers removeObject:reg];
}

-(GMPI2CRegister*) registerWithNumber:(NSInteger) number{
    for (GMPI2CRegister * reg in self.registers) {
        if(reg.number == number){
            return reg;
        }
    }
    return nil;
}

@end
