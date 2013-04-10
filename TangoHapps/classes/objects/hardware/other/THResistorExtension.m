//
//  THResistorExtension.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THResistorExtension.h"
#import "THBoardPinEditable.h"
#import "THLilypadEditable.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"

@implementation THResistorExtension

-(void) loadSprite{
    self.sprite = [CCSprite spriteWithFile:@"resistorExtension.png"];
    [self addChild:self.sprite z:-1];
}

-(id) init {
    self = [super init];
    if(self){
        [self loadSprite];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    self.pin = [decoder decodeObjectForKey:@"pin"];
    
    [self loadSprite];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_pin forKey:@"pin"];
}

-(id)copyWithZone:(NSZone *)zone {
    THResistorExtension * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(void) setPin:(THElementPinEditable *)pin{
    _pin = pin;
    //[self addChild:pin];
}

-(BOOL) acceptsConnectionsTo:(TFEditableObject *)anObject{
    
    if([anObject isKindOfClass:[THLilyPadEditable class]]){
        return YES;
    }

    if([anObject isKindOfClass:[THBoardPinEditable class]]){
        THBoardPinEditable * boardPin = (THBoardPinEditable*) anObject;
        if(boardPin.type == kPintypeDigital){
            return YES;
        }
    }
    return NO;
}
/*
-(void) draw{
    //[self.pin draw];
}*/

-(NSString*) description{
    return @"resistor extension";
}

-(void) prepareToDie{
    [self.pin prepareToDie];
    
    _pin = nil;
}

@end
