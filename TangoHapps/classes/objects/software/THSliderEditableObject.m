//
//  THSliderEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSliderEditableObject.h"
#import "THSlider.h"
#import "THSliderProperties.h"

@implementation THSliderEditableObject

@dynamic value;
@dynamic min;
@dynamic max;

-(void) load{
    self.acceptsConnections = YES;
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THSlider alloc] init];
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    THSliderEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THSliderProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(float) value{
    THSlider * object = (THSlider*) self.simulableObject;
    return object.value;
}

-(void) setValue:(float)value{
    THSlider * object = (THSlider*) self.simulableObject;
    object.value = value;
}

-(float) min{
    THSlider * object = (THSlider*) self.simulableObject;
    return object.min;
}

-(void) setMin:(float)min{
    THSlider * object = (THSlider*) self.simulableObject;
    object.min = min;
}

-(float) max{
    THSlider * object = (THSlider*) self.simulableObject;
    return object.max;
}

-(void) setMax:(float)max{
    THSlider * object = (THSlider*) self.simulableObject;
    object.max = max;
}


-(NSString*) description{
    return @"Slider";
}


@end
