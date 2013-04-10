//
//  THPinValue.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/24/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPinValue.h"

@implementation THPinValue
#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.number = [decoder decodeIntegerForKey:@"number"];
    self.type = [decoder decodeIntegerForKey:@"type"];
    self.value = [decoder decodeIntegerForKey:@"value"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.number forKey:@"number"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeInt:self.value forKey:@"value"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THPinValue * copy = [[THPinValue alloc] init];
    
    copy.number = self.number;
    copy.type = self.type;
    copy.value = self.value;
    
    return copy;
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%d (%d) = %d",self.number,self.type,self.value];
}
@end
