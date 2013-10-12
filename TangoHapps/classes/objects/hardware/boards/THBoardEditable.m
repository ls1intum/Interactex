//
//  THBoardEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoardEditable.h"

@implementation THBoardEditable

-(THBoardPinEditable*) minusPin{
    NSLog(@"Warning, THBoard subclasses should implement method minusPin");
    return nil;
}

-(THBoardPinEditable*) plusPin{
    NSLog(@"Warning, THBoard subclasses should implement method plusPin");
    return  nil;
}

-(THBoardPinEditable*) pinAtPosition:(CGPoint) position{
    NSLog(@"Warning, THBoard subclasses should implement method pinAtPosition");
    return nil;
}


#pragma mark - Object's Lifecycle

-(void) addToLayer:(TFLayer *)layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addBoard:self];
}

-(void) removeFromWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeBoard:self];
    [super removeFromWorld];
}

/*
-(void) prepareToDie{
    
    for (THElementPinEditable * pin in _pins) {
        [pin prepareToDie];
    }
    
    _pins = nil;
    [super prepareToDie];
}*/

@end
