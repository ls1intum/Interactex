//
//  THiPhoneControlEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneControlEditableObject.h"
#import "THiPhoneControl.h"
#import "THHardwareComponentEditableObject.h"
#import "THConditionEditableObject.h"
#import "THEditor.h"

@implementation THiPhoneControlEditableObject

@dynamic events;

-(void) load{
    self.acceptsConnections = YES;
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
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

#pragma mark - Methods

-(void) setEnabled:(BOOL) enabled{
    THiPhoneControl * control = (THiPhoneControl*) self.simulableObject;
    control.enabled = enabled;
}

-(BOOL) enabled{
    
    THiPhoneControl * control = (THiPhoneControl*) self.simulableObject;
    return control.enabled;
}


#pragma mark - Lifecycle
/*
-(void) addToLayer:(THCustomEditor*) editor{
    [self willStartEdition];
    [super addToLayer:editor];
}*/

-(void) willStartSimulation{
    self.enabled = YES;
    [super willStartSimulation];
}

-(void) willStartEdition{
    self.enabled = NO;
    [super willStartEdition];
}

#pragma mark - Dealloc

-(void) prepareToDie{
    
    [super prepareToDie];
}

-(NSString*) description{
    return @"iPhone Control";
}

@end
