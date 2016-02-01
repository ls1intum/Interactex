//
//  THPeakDetectorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 01/02/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THPeakDetectorEditable.h"
#import "THPeakDetector.h"

@implementation THPeakDetectorEditable

@dynamic peak;
@dynamic peakIdx;

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THPeakDetector alloc] init];
        
        [self loadPeakDetector];
    }
    return self;
}

-(void) loadPeakDetector{
    
    self.programmingElementType = kProgrammingElementTypePeakDetector;
    self.acceptsConnections = YES;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        [self loadPeakDetector];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THPeakDetectorEditable * copy = [super copyWithZone:zone];
    if(copy){
    }
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    //[controllers addObject:[THSignalDeviationProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) update{
    
}

-(void) addSample:(float)value{
    
    THPeakDetector * peakDetector = (THPeakDetector*) self.simulableObject;
    [peakDetector addSample:value];
}

-(float) peak{
    THPeakDetector * peakDetector = (THPeakDetector*) self.simulableObject;
    return peakDetector.peak;
}

-(NSInteger) peakIdx{
    THPeakDetector * peakDetector = (THPeakDetector*) self.simulableObject;
    return peakDetector.peakIdx;
}

-(NSString*) description{
    return @"PeakDetector";
}

@end
