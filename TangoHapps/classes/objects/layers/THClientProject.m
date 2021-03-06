/*
THClientProject.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THClientProject.h"
#import "THSimulableWorldController.h"
#import "TFEventActionPair.h"

@implementation THClientProject

#pragma mark - static methods

+(BOOL) doesProjectExistWithName:(NSString*) name{
    return [TFFileUtils dataFile:name existsInDirectory:kProjectsDirectory];
}

+(NSString*) nextProjectNameForName:(NSString*) name{
    
    int i = 2;
    NSString * finalName = name;
    while([self doesProjectExistWithName:finalName]){
        finalName = [NSString stringWithFormat:@"%@ %d",name,i];
        i++;
    }
    return finalName;
}

+(id)emptyProject {
    return [[THClientProject alloc] init];
}

+(THClientProject*) projectSavedWithName:(NSString*) name inDirectory:(NSString*) directory{
    
    NSString * fileName = [TFFileUtils dataFile:name inDirectory:directory];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
}

+(THClientProject*) projectSavedWithName:(NSString*) name {
    return [self projectSavedWithName:name inDirectory:kProjectsDirectory];
}

+(BOOL) renameProjectNamed:(NSString*) name toName:(NSString*) newName{
    if([TFFileUtils dataFile:newName existsInDirectory:kProjectsDirectory])
        return NO;
    
    return [TFFileUtils renameDataFile:name to:newName inDirectory:kProjectsDirectory];
}

#pragma mark - initialization

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        [self load];
    }
    return self;
}

-(void) load{
    
    _boards = [NSMutableArray array];
    _hardwareComponents = [NSMutableArray array];
    _iPhoneObjects = [NSMutableArray array];
    _visualProgrammingObjects = [NSMutableArray array];
    _actionPairs = [NSMutableArray array];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        
        [self load];
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.boards = [decoder decodeObjectForKey:@"boards"];
        self.hardwareComponents = [decoder decodeObjectForKey:@"clotheObjects"];
        self.iPhoneObjects = [decoder decodeObjectForKey:@"iPhoneObjects"];
        self.iPhone = [decoder decodeObjectForKey:@"iPhone"];
        self.visualProgrammingObjects = [decoder decodeObjectForKey:@"values"];
        
        NSMutableArray * actionPairs = [decoder decodeObjectForKey:@"actionPairs"];
        for (TFEventActionPair * pair in actionPairs) {
            [self registerAction:pair.action forEvent:pair.event];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    
    [coder encodeObject:self.boards forKey:@"boards"];
    [coder encodeObject:self.hardwareComponents forKey:@"clotheObjects"];
    [coder encodeObject:self.iPhoneObjects forKey:@"iPhoneObjects"];
    if(self.iPhone != nil)
        [coder encodeObject:self.iPhone forKey:@"iPhone"];
    
    [coder encodeObject:self.visualProgrammingObjects forKey:@"values"];
    
    [coder encodeObject:self.actionPairs forKey:@"actionPairs"];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone{
    THClientProject * copy = [[THClientProject alloc] initWithName:self.name];
    //TODO implement
    return copy;
}

#pragma mark - Methods

-(THBoard*) currentBoard{
    if(self.boards.count == 0){
        return nil;
    }
    return [self.boards objectAtIndex:0];
}

-(void) registerAction:(TFAction*) action forEvent:(TFEvent*) event {
    
    //NSLog(@"registering: %@ %@ %@",action.source, event.name, action.target);
    
    TFEventActionPair * pair = [[TFEventActionPair alloc] init];
    pair.action = action;
    pair.event = event;
    [_actionPairs addObject:pair];
    
    NSAssert(action.source != nil, @"trying to register a nil action source for %@",action);
    NSAssert(action.target != nil, @"trying to register a nil action target for %@",action);
    NSAssert(event.name != nil, @"trying to register a nil event name for %@",action);
    
    [[NSNotificationCenter defaultCenter] addObserver:action selector:@selector(startAction) name:event.name object:action.source];
}

-(NSArray*) allObjects {
    NSArray * allObjects = [self.hardwareComponents arrayByAddingObjectsFromArray:self.iPhoneObjects];
    
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.boards];
    allObjects = [allObjects arrayByAddingObjectsFromArray:self.visualProgrammingObjects];
    return allObjects;
}

-(void) startSimulating {
    [self willStartSimulating];
    [self didStartSimulating];
}

-(void) stopSimulating {
    for (TFSimulableObject * object in self.allObjects) {
        [object stopSimulating];
    }
}

-(void) willStartSimulating {
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

-(void) saveToDirectory:(NSString*) directory {
    
    NSString *filePath = [TFFileUtils dataFile:self.name inDirectory:directory];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    if(!success){
        NSLog(@"failed to save object at path: %@",filePath);
    }
}

-(void) save {
    
    [self saveToDirectory:kProjectsDirectory];
}

-(void) dealloc{
    [self prepareAllObjectsToDie];
}

@end
