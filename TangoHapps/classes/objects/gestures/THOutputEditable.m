//
//  THOutputEditable.m
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THOutputEditable.h"
#import "THOutput.h"

@implementation THOutputEditable

-(void) load{
    
    self.simulableObject = [[THOutput alloc] init];
    
    self.sprite = [CCSprite spriteWithFile:@"output.png"];
    [self addChild:self.sprite];
    
    self.canBeAddedToGesture = YES;
    self.acceptsConnections = YES;
    
    self.scale = 1;
    
}

-(id) init{
    self = [super init];
    if(self){
        
        [self load];
    }
    return self;
}

-(NSString*) description{
    return @"Output";
}

@end
