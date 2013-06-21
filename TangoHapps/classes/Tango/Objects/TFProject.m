/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


#import "TFProject.h"
#import "TFEditableObject.h"
#import "TFEventActionPair.h"
#import "TFAction.h"
#import "TFConnectionLine.h"
#import "TFEvent.h"

@implementation TFProject

@dynamic allObjects;

+(TFProject*)emptyProject {
    return [[TFProject alloc] init];
}

-(void) load {
    _eventActionPairs = [NSMutableArray array];
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        _name = name;
        [self load];
    }
    return self;
}


#pragma mark - Archiving

-(void) save{
    
    NSString * filePath = [TFFileUtils dataFile:self.name
                                         inDirectory:kProjectsDirectory];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+(TFProject*) restoreProjectNamed:(NSString*) name{
    
    NSString *filePath = [TFFileUtils dataFile:name
                                   inDirectory:kProjectsDirectory];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self){
        
        [self load];
        
        _name = [decoder decodeObjectForKey:@"name"];
        
        NSArray * eventActionPairs = [decoder decodeObjectForKey:@"eventActionPairs"];
        
        for(TFEventActionPair * pair in eventActionPairs){
            [self registerAction:pair.action forEvent:pair.event];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_eventActionPairs forKey:@"eventActionPairs"];
}

#pragma mark - Objects

-(TFEditableObject*) objectAtLocation:(CGPoint) location{
    return nil;
}

-(NSArray*) allObjects{
    return nil;
}

-(void) notifyObjectAdded:(TFEditableObject*) object{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectAdded object:object];
}

-(void) notifyObjectRemoved:(TFEditableObject*) object{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationObjectRemoved object:object];
}

#pragma mark - Actions

-(NSMutableArray*) actionsForTarget:(TFEditableObject*) target{
    NSMutableArray * array = [NSMutableArray array];
    for (TFEventActionPair * pair in _eventActionPairs) {
        if(pair.action.target == target){
            [array addObject:pair];
        }
    }
    return array;
}

-(NSMutableArray*) actionsForSource:(TFEditableObject*) source{
    NSMutableArray * array = [NSMutableArray array];
    for (TFEventActionPair * pair in _eventActionPairs) {
        if(pair.action.source == source){
            [array addObject:pair];
        }
    }
    return array;
}

-(void) deregisterActionsForObject:(TFEditableObject*) object{
    NSMutableArray * toRemove = [NSMutableArray array];
    for (TFEventActionPair * pair in _eventActionPairs) {
        if(pair.action.target == object || pair.action.source == object){
            [toRemove addObject:pair];
        }
    }
    
    for (TFEventActionPair * pair in toRemove) {
        [self deregisterAction:pair.action];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:object];
}

-(void) removeConnectionsBetween:(TFEditableObject*) obj1 and:(TFEditableObject*) obj2{
    
    TFConnectionLine * connectionToRemove = nil;
    for (TFConnectionLine * connection in obj1.connections) {
        TFEditableObject * obj = connection.obj2;
        if(obj2 == obj){
            connectionToRemove = connection;
        }
    }
    if(connectionToRemove != nil){
        [obj1.connections removeObject:connectionToRemove];
    }
}

-(void) deregisterAction:(TFAction*) action{
    TFEventActionPair * toRemove;
    NSInteger idx = 0;
    for (TFEventActionPair * pair in _eventActionPairs) {
        if(pair.action == action){
            toRemove = pair;
            break;
        }
        idx++;
    }
    [_eventActionPairs removeObject:toRemove];
    [toRemove.action.source removeConnectionTo:toRemove.action.target];
    //[self removeConnectionsBetween:toRemove.action.source and:toRemove.action.target];
    
    TFEditableObject * editable = toRemove.action.source;
    [[NSNotificationCenter defaultCenter] removeObserver:action name:toRemove.event.name object:editable.simulableObject];
}

-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event{
    
    TFEventActionPair * pair = [[TFEventActionPair alloc] init];
    pair.action = action;
    pair.event = event;
    [_eventActionPairs addObject:pair];
    
    TFEditableObject * source = action.source;
    TFEditableObject * target = action.target;
    
    [source handleRegisteredAsSourceForAction:action];
    [target handleRegisteredAsTargetForAction:action];
    
    [[NSNotificationCenter defaultCenter] addObserver:action selector:@selector(startAction) name:event.name object:((TFEditableObject*)action.source).simulableObject];
}

#pragma mark - Other

-(void) prepareToDie{
    for (TFEditableObject * object in self.allObjects) {
        [object prepareToDie];
    }
    
    for (TFEventActionPair * pair in _eventActionPairs) {
        [pair.action prepareToDie];
    }
}

-(void) willStartSimulation{
    for (TFEditableObject * object in self.allObjects) {
        [object willStartSimulation];
    }
}

-(void) didStartSimulation{
    for (TFEditableObject * editable in self.allObjects) {
        [editable didStartSimulation];
    }
}

-(void) prepareForEdition{
    for (TFEditableObject * object in self.allObjects) {
        [object willStartEdition];
    }
}

#pragma mark - Methods

-(BOOL) isEmpty{
    return (self.allObjects.count == 0);
}

-(NSString*) resolveNameConflictFor:(NSString*) name{
    NSInteger i = 2;
    while([TFFileUtils dataFile:name existsInDirectory:kProjectsDirectory]){
        name = [NSString stringWithFormat:@"%@%d",name,i++];
    }
    return name;
}

-(void) setName:(NSString*)newName {
    _name = newName;
    /*
    if(![newName isEqualToString:_name]){
        newName = [self resolveNameConflictFor:newName];
        [TFFileUtils renameDataFile:_name to:newName inDirectory:kProjectsDirectory];
        _name = newName;
    }*/
}

-(NSString*) description{
    return @"Project";
}

-(void) dealloc{
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
