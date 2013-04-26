//
//  THClientScene.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientProject.h"
#import "THSimulableWorldController.h"

@implementation THClientProject

+(id)emptyProject {
    return [[THClientProject alloc] init];
}

-(void) load{
    
    _clotheObjects = [NSMutableArray array];
    _iPhoneObjects = [NSMutableArray array];
    _conditions = [NSMutableArray array];
    _values = [NSMutableArray array];
    _actions = [NSMutableArray array];
    _actionPairs = [NSMutableArray array];
    _triggers = [NSMutableArray array];
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
    self = [super init];
    if(self){
        
        [self load];
        
        self.clotheObjects = [decoder decodeObjectForKey:@"clotheObjects"];
        self.iPhoneObjects = [decoder decodeObjectForKey:@"iPhoneObjects"];
        self.iPhone = [decoder decodeObjectForKey:@"iPhone"];
        self.conditions = [decoder decodeObjectForKey:@"conditions"];
        self.values = [decoder decodeObjectForKey:@"values"];
        self.triggers = [decoder decodeObjectForKey:@"triggers"];
        self.actions = [decoder decodeObjectForKey:@"actions"];
        self.lilypad = [decoder decodeObjectForKey:@"lilypad"];
        
        NSMutableArray * actionPairs = [decoder decodeObjectForKey:@"actionPairs"];
        for (TFEventActionPair * pair in actionPairs) {
            [self registerAction:pair.action forEvent:pair.event];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.clotheObjects forKey:@"clotheObjects"];
    [coder encodeObject:self.iPhoneObjects forKey:@"iPhoneObjects"];
    if(self.iPhone != nil)
        [coder encodeObject:self.iPhone forKey:@"iPhone"];
    
    [coder encodeObject:self.conditions forKey:@"conditions"];
    [coder encodeObject:self.values forKey:@"values"];
    [coder encodeObject:self.triggers forKey:@"triggers"];
    [coder encodeObject:self.actions forKey:@"actions"];
    [coder encodeObject:self.lilypad forKey:@"lilypad"];
    
    [coder encodeObject:self.actionPairs forKey:@"actionPairs"];
}

-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event{
    
    TFEventActionPair * pair = [[TFEventActionPair alloc] init];
    pair.action = action;
    pair.event = event;
    [_actionPairs addObject:pair];
    
    [[NSNotificationCenter defaultCenter] addObserver:action selector:@selector(startAction) name:event.name object:action.source];
}

-(NSArray*) allObjects{
    NSArray * allObjects = [self.clotheObjects arrayByAddingObjectsFromArray:self.iPhoneObjects];
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.conditions];
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.actions];
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.triggers];
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.values];
    return allObjects;
}

-(void) startSimulating{
    [self willStartSimulating];
    [self didStartSimulating];
}

-(void) willStartSimulating{
    for (TFSimulableObject * object in self.allObjects) {
        [object willStartSimulating];
    }
}

-(void) didStartSimulating{
    for (TFSimulableObject * object in self.allObjects) {
        [object didStartSimulating];
    }
}

-(void) prepareAllObjectsToDie{
    
    NSArray * allObjects = [self allObjects];
    for (TFSimulableObject * object in allObjects) {
        [object prepareToDie];
    }
    for (TFEventActionPair * pair in self.actionPairs) {
        [pair.action prepareToDie];
    }
}

-(void) dealloc{
    NSLog(@"deallocing thworld");
    [self prepareAllObjectsToDie];
}

@end
