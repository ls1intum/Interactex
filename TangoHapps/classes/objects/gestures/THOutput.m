//
//  THOutput.m
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THOutput.h"

@implementation THOutput

-(void) load{
    
    TFProperty * property = [TFProperty propertyWithName:@"output" andType:kDataTypeAny];
    self.properties = [NSMutableArray arrayWithObjects:property,nil];
    
    TFMethod * method =  [TFMethod methodWithName:@"setOutput"];
    self.methods = [NSMutableArray arrayWithObjects:method, nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventValueChanged];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THOutput * copy = [super copyWithZone:zone];
    
    [copy load];
    
    return copy;
}

-(void) setOutput {
    
}

@end
