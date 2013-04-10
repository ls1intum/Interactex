//
//  THTouchPadEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THTouchPadEditableObject.h"
#import "THTouchpad.h"
#import "THTouchpadProperties.h"

@implementation THTouchPadEditableObject
@dynamic dx;
@dynamic dy;
@dynamic xMultiplier;
@dynamic yMultiplier;

-(void) load{
    self.acceptsConnections = YES;
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THTouchpad alloc] init];
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
    THTouchPadEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THTouchpadProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(float) xMultiplier{
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    return object.xMultiplier;
}

-(float) yMultiplier{
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    return object.yMultiplier;
}

-(void) setXMultiplier:(float)xMultiplier{
    
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    object.xMultiplier = xMultiplier;
}

-(void) setYMultiplier:(float)yMultiplier{
    
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    object.yMultiplier = yMultiplier;
}

-(float) dx{
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    return object.dx;
}

-(float) dy{
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    return object.dy;
}

-(void) setDx:(float)dx{
    
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    object.dx = dx;
}

-(void) setDy:(float)dy{
    
    THTouchpad * object = (THTouchpad*) self.simulableObject;
    object.dy = dy;
}

-(void) prepareToDie{
    [super prepareToDie];
}

-(NSString*) description{
    return @"TouchPad";
}

@end
