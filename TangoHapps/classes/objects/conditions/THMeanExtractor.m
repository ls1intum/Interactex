//
//  THMeanExtractor.m
//  TangoHapps
//
//  Created by Juan Haladjian on 09/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THMeanExtractor.h"

@implementation THMeanExtractor


-(id) init{
    self = [super init];
    if(self){
        [self loadMeanExtractor];
        
    }
    return self;
}

-(void) loadMeanExtractor{
    
    TFProperty * property = [TFProperty propertyWithName:@"mean" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method = [TFMethod methodWithName:@"addSample"];
    method.numParams = 1;
    method.firstParamType = kDataTypeFloat;
    
    self.methods = [NSMutableArray arrayWithObjects:method,nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventMeanChanged];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObject:event];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadMeanExtractor];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THMeanExtractor * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(float) computeMean{
    
    _mean = 0;
    
    for (NSNumber * number in self.data) {
        
        _mean += number.floatValue;
    }
    
    _mean = _mean / (float) self.data.count;
    
    return _mean;
}


-(void) emptyWindow{
    
    [self.data removeAllObjects];
}

-(void) addSample:(float) sample{
    [self.data addObject:[NSNumber numberWithFloat:sample]];
    if(self.data.count >= kFilterMaxSamples){
        [self computeMean];
        [self emptyWindow];
    }
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventMeanChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"meanExtractor";
}


@end
