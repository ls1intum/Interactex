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
    

    self.properties = [NSMutableArray array];
    
    TFMethod * method =  [TFMethod methodWithName:@"setOutput"];
    method.numParams = 1;
    method.firstParamType = kDataTypeAny;
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

-(void) setOutput:(NSObject*) object {
//-(void) setOutput {
    _value = object;
}

-(void) setPropertyType:(TFDataType)type {
    self.properties = [NSMutableArray array];
    TFProperty * property = [TFProperty propertyWithName:@"output" andType:type];
    [self.properties addObject:property];
}

@end
