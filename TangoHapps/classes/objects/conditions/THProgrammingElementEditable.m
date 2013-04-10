//
//  THProgrammingElementEditable.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@implementation THProgrammingElementEditable

-(id) init{
    self = [super init];
    if(self){
        
        [self loadProgElement];
    }
    return self;
}

-(void) loadProgElement{
    self.z = kValueZ;
    self.acceptsConnections = YES;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadProgElement];
    
    return self;
}

#pragma mark - World Interaction

-(void) addToLayer:(TFLayer *)layer{
    [layer addEditableObject:self];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(void) addToWorld{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addValue:self];
}

-(void) removeFromWorld{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project removeValue:self];
    [super removeFromWorld];
}

@end
