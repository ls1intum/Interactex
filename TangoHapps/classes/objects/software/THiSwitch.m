//
//  THiSwitch.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/4/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THiSwitch.h"

@implementation THiSwitch
@dynamic on;

-(void) loadSwitch{
    
    UISwitch * iswitch = [[UISwitch alloc] init];
    self.view = iswitch;
    
    self.width = iswitch.frame.size.width;
    self.height = iswitch.frame.size.height;
    
    [iswitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    TFProperty * property = [TFProperty propertyWithName:@"on" andType:kDataTypeBoolean];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFEvent * event1 = [TFEvent eventNamed:@"switchOn"];
    TFEvent * event2 = [TFEvent eventNamed:@"switchOff"];
    TFEvent * event3 = [TFEvent eventNamed:kEventOnChanged];
    event3.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObjects:event1,event2,event3, nil];
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadSwitch];
        self.on = YES;
        self.enabled = YES;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadSwitch];
    self.on = [decoder decodeBoolForKey:@"on"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.on forKey:@"on"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THiSwitch * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(BOOL) on{
    UISwitch * iswitch = (UISwitch*) self.view;
    return iswitch.on;
}

-(void) setOn:(BOOL)on{
    UISwitch * iswitch = (UISwitch*) self.view;
    iswitch.on = on;
}

-(void) setEnabled:(BOOL) enabled{
    
    ((UISwitch*)self.view).enabled = enabled;
    [super setEnabled:enabled];
}

-(BOOL) enabled{
    return ((UISwitch*)self.view).enabled;
}

-(void) stateChanged:(id) sender{
    TFEvent * event;
    if(self.on){
        event = [self.events objectAtIndex:0];
    } else {
        event = [self.events objectAtIndex:1];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:event.name  object:self];
    [self triggerEventNamed:kEventOnChanged];
}

-(void) didStartSimulating{
    [self triggerEventNamed:kEventOnChanged];
}

-(NSString*) description{
    return @"ibutton";
}

@end
