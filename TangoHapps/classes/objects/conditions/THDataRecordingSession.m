//
//  THDataRecordingSession.m
//  TangoHapps
//
//  Created by Juan Haladjian on 01/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THDataRecordingSession.h"

@implementation THDataRecordingSession


-(id) init{
    self = [super init];
    if(self){
        [self loadDataRecordingSession];
        
    }
    return self;
}

-(void) loadDataRecordingSession{
    TFMethod * startMethod = [TFMethod methodWithName:@"start"];
    TFMethod * addSampleMethod = [TFMethod methodWithName:@"addSample"];
    addSampleMethod.numParams = 1;
    addSampleMethod.firstParamType = kDataTypeAny;
    TFMethod * stopMethod = [TFMethod methodWithName:@"stop"];
    
    self.methods = [NSMutableArray arrayWithObjects:startMethod,stopMethod,addSampleMethod, nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventRecordingFinished];
    TFProperty * property = [[TFProperty alloc] initWithName:@"data" andType:kDataTypeAny];
    
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadDataRecordingSession];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THDataRecordingSession * copy = [super copyWithZone:zone];
    return copy;
}

#pragma mark - Methods

-(void) start{
    _started = YES;
    self.data = [NSMutableArray array];
}

-(void) stop{
    _started = NO;
    [super triggerEventNamed:kEventRecordingFinished];
}

-(void) addSample:(id) sample{
    if(self.started){
        [self.data addObject:sample];
    }
}

@end
