//
//  THTriggerEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTriggerEditable.h"

@implementation THTriggerEditable

-(id)init{
    self = [super init];
    if(self) {
        _actions = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _actions =  [decoder decodeObjectForKey:@"actions"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_actions forKey:@"actions"];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THTriggerEditable * copy = [super copyWithZone:zone];
    
    copy.actions = _actions;
    
    return copy;
}

#pragma mark - World interaction

-(void) addToWorld{
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project addTrigger:self];
}

-(void) removeFromWorld{
    THCustomProject * project = (THCustomProject*) [THDirector sharedDirector].currentProject;
    [project removeTrigger:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

#pragma mark - Methods

-(void) addAction:(TFAction *) action{
    [_actions addObject:action];
}

-(void) removeAction:(TFAction*) action{
    [_actions removeObject:action];
}

@end
