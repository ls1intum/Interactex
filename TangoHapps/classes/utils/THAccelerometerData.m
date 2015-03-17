//
//  THAccelerometerData.m
//  TangoHapps
//
//  Created by Juan Haladjian on 16/03/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THAccelerometerData.h"

@implementation THAccelerometerData

-(id)copyWithZone:(NSZone *)zone{
    
    THAccelerometerData * copy = [super init];
    copy.x = self.x;
    copy.y = self.y;
    copy.z = self.z;
    
    return copy;
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%.3f %.3f %.3f",self.x,self.y,self.z];
}

@end


