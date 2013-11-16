//
//  THBoardEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoardEditable.h"
#import "TFLayer.h"
#import "THElementPinEditable.h"
#import "THBoardPinEditable.h"

@implementation THBoardEditable

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        self.pins = [decoder decodeObjectForKey:@"pins"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.pins forKey:@"pins"];
}

#pragma mark - Methods

-(THBoardPinEditable*) minusPin{
    NSLog(@"Warning, THBoard subclasses should implement method minusPin");
    return nil;
}

-(THBoardPinEditable*) plusPin{
    NSLog(@"Warning, THBoard subclasses should implement method plusPin");
    return  nil;
}

-(THBoardPinEditable*) sclPin{
    NSLog(@"Warning, THBoard subclasses should implement method sclPin");
    return nil;
}

-(THBoardPinEditable*) sdaPin{
    NSLog(@"Warning, THBoard subclasses should implement method sdaPin");
    return  nil;
}

-(NSInteger) pinNumberAtPosition:(CGPoint) position{
    
    for (THBoardPinEditable * pin in self.pins) {
        if([pin testPoint:position]){
            return pin.number;
        }
    }
    
    return -1;
}

-(THPinEditable*) pinAtPosition:(CGPoint) position{
    for (THBoardPinEditable * pin in self.pins) {
        if([pin testPoint:position]){
            return pin;
        }
    }
    
    return nil;
}

-(THBoardPinEditable*) digitalPinWithNumber:(NSInteger) number{
    return nil;
}

-(THBoardPinEditable*) analogPinWithNumber:(NSInteger) number{
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


-(void) prepareToDie{
    
    for (THElementPinEditable * pin in _pins) {
        [pin prepareToDie];
    }
    
    _pins = nil;
    [super prepareToDie];
}

@end
