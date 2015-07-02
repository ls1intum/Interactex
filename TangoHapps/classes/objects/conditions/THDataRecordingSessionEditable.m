//
//  THDataRecordingSessionEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 01/07/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THDataRecordingSessionEditable.h"
#import "THDataRecordingSession.h"

@implementation THDataRecordingSessionEditable

@dynamic started;
@dynamic data;

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THDataRecordingSession alloc] init];
        
        [self loadDataRecordingSession];
    }
    return self;
}

-(void) loadDataRecordingSession{
    
    self.programmingElementType = kProgrammingElementTypeDataRecordingSession;
    self.acceptsConnections = YES;
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
    THDataRecordingSessionEditable * copy = [super copyWithZone:zone];
    if(copy){
    }
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObjectsFromArray:[super propertyControllers]];
    //[controllers addObject:[THCustomComponentProperties properties]];
    return controllers;
}

#pragma mark - Methods

-(void) start{
    THDataRecordingSession * dataSession = (THDataRecordingSession*) self.simulableObject;
    [dataSession start];
}

-(void) stop{
    THDataRecordingSession * dataSession = (THDataRecordingSession*) self.simulableObject;
    [dataSession stop];
}

-(void) addSample:(id) sample{
    THDataRecordingSession * dataSession = (THDataRecordingSession*) self.simulableObject;
    [dataSession addSample:sample];
}

-(BOOL) started{
    THDataRecordingSession * dataSession = (THDataRecordingSession*) self.simulableObject;
    return dataSession.started;
}

-(NSMutableArray*) data{
    THDataRecordingSession * dataSession = (THDataRecordingSession*) self.simulableObject;
    return dataSession.data;
}

@end
