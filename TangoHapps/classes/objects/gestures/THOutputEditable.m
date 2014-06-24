//
//  THOutputEditable.m
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THOutputEditable.h"
#import "THOutput.h"
#import "THGestureEditableObject.h"

@implementation THOutputEditable

-(void) load{

    self.simulableObject = [[THOutput alloc] init];
    
    self.sprite = [CCSprite spriteWithFile:@"outputEmpty.png"];
    [self addChild:self.sprite];
    
    self.canBeAddedToGesture = YES;
    self.acceptsConnections = YES;
    self.canBeMoved = NO;
    self.canBeDuplicated = NO;
    
    self.scale = 1;
    

    
}

-(id) init{
    self = [super init];
    if(self){
        
        [self load];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        [self load];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THOutputEditable * copy = [super copyWithZone:zone];
    
    [copy load];
    
    return copy;
}


-(void) setOutput:(id) value {
    THOutput * obj = (THOutput*) self.simulableObject;
    [obj setOutput:value];
}

-(void) chooseSprite {
    
}

-(void) removeFromWorld{
    [self.attachedToGesture deattachOutput:self];
    [super removeFromWorld];
}

-(void) prepareToDie{
    [super prepareToDie];
}

-(id) value {
    THOutput * obj = (THOutput*) self.simulableObject;
    return obj.value;
}

-(NSString*) description{
    return @"Output";
}

@end
