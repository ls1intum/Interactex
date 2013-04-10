//
//  THiSwitchEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THiSwitchEditableObject.h"
#import "THiSwitch.h"
#import "THiSwitchEditableProperties.h"

@implementation THiSwitchEditableObject
@dynamic on;

-(void) loadSwitch{
    
    self.canChangeBackgroundColor = NO;
    self.canBeResized = NO;
    self.enabled = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THiSwitch alloc] init];
        [self loadSwitch];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadSwitch];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THiSwitchEditableProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) press{
    
}

-(BOOL) on{
    THiSwitch * iswitch = (THiSwitch*) self.simulableObject;
    return iswitch.on;
}

-(void) setOn:(BOOL)on{
    THiSwitch * iswitch = (THiSwitch*) self.simulableObject;
    iswitch.on = on;
}

-(NSString*) description{
    return @"iButton";
}

@end
