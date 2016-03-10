//
//  THMeanExtractorEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 09/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THMeanExtractorEditable.h"
#import "THMeanExtractor.h"

@implementation THMeanExtractorEditable

@dynamic mean;

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THMeanExtractor alloc] init];
        
        [self loadMeanExtractor];
    }
    return self;
}

-(void) loadMeanExtractor{
    
    self.programmingElementType = kProgrammingElementTypeMeanExtractor;
    self.acceptsConnections = YES;
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
    THMeanExtractorEditable * copy = [super copyWithZone:zone];
    if(copy){
    }
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    //[controllers addObject:[THMeanExtractorProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) update{
    
}

-(void) addSample:(float)value{
    
    THMeanExtractor * meanExtractor = (THMeanExtractor*) self.simulableObject;
    [meanExtractor addSample:value];
}

-(float) mean{
    THMeanExtractor * meanExtractor = (THMeanExtractor*) self.simulableObject;
    return meanExtractor.mean;
}

-(void) setMean:(float)v{
    THMeanExtractor * meanExtractor = (THMeanExtractor*) self.simulableObject;
    meanExtractor.mean = v;
}

-(NSString*) description{
    return @"MeanExtractor";
}


@end
