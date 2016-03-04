//
//  THWindowEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THWindowEditable.h"
#import "THWindow.h"

@implementation THWindowEditable

@dynamic windowSize;
@dynamic overlap;
@dynamic started;
@dynamic data;

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THWindow alloc] init];
        
        [self loadWindow];
    }
    return self;
}

-(void) loadWindow{
    
    self.programmingElementType = kProgrammingElementTypeWindow;
    self.acceptsConnections = YES;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        [self loadWindow];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THWindow * copy = [super copyWithZone:zone];
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
    THWindow * window = (THWindow*) self.simulableObject;
    [window start];
}

-(void) stop{
    THWindow * window = (THWindow*) self.simulableObject;
    [window stop];
}

-(void) addSample:(id) sample{
    THWindow * window = (THWindow*) self.simulableObject;
    [window addSample:sample];
}

-(BOOL) started{
    THWindow * window = (THWindow*) self.simulableObject;
    return window.started;
}

-(NSMutableArray*) data{
    THWindow * window = (THWindow*) self.simulableObject;
    return window.data;
}

-(void) setWindowSize:(NSInteger)windowSize{
    THWindow * window = (THWindow*) self.simulableObject;
    window.windowSize = windowSize;
}


-(NSInteger) windowSize{
    THWindow * window = (THWindow*) self.simulableObject;
    return window.windowSize;
}

-(void) setOverlap:(NSInteger)overlap{
   THWindow * window = (THWindow*) self.simulableObject;
    window.overlap = overlap;
}

-(NSInteger) overlap{
    THWindow * window = (THWindow*) self.simulableObject;
    return window.overlap;
}

@end
