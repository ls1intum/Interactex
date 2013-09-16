//
//  THActionEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THActionEditable.h"

@implementation THActionEditable

#pragma mark - Archiving

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        //self.source = [decoder decodeObjectForKey:@"source"];
        self.target = [decoder decodeObjectForKey:@"target"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    //[coder encodeObject:self.source forKey:@"source"];
    [coder encodeObject:self.target forKey:@"target"];
}

-(id)copyWithZone:(NSZone *)zone {
    TFAction * copy = [[[self class] alloc] init];
    //copy.source = self.source;
    copy.target = self.target;
    
    return copy;
}

#pragma mark - World interaction

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addAction:self];
}

-(void) removeFromWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeAction:self];
    [super removeFromWorld];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer*) layer{
    [layer removeEditableObject:self];
}

@end
