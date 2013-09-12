//
//  THLilypadEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/22/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLilyPadEditable.h"
#import "THPinEditable.h"
#import "THLilyPad.h"
#import "THBoardPinEditable.h"
#import "THLilypadProperties.h"

@implementation THLilyPadEditable
@synthesize pins = _pins;
@dynamic numberOfDigitalPins;
@dynamic numberOfAnalogPins;


CGPoint kLilypadPinPositions[kLilypadNumberOfPins] = {{5,105},{-25,102},{-53.0, 90.0},{-76.0, 72.0},{-94.0, 46.0},{-103.0, 19.0},{-104.0, -11.0},{-97.0, -41.0},{-81.0, -67.0},{-59.0, -88.0},{-33.0, -101.0},{-3.0, -106.0},
    
    {28.0, -102.0},{56.0, -93.0},{79.0, -73.0},{97.0, -48.0},{107.0, -20.0},{106.0, 11.0},{100.0, 39.0},{84.0, 65.0},{62.0, 86.0},{34,100}
};

-(void) loadLilypad{
    self.z = kLilypadZ;
    
    self.sprite = [CCSprite spriteWithFile:@"lilypad.png"];
    [self addChild:self.sprite];
    
    self.canBeDuplicated = NO;
}

-(void) addPins{
    for (THPinEditable * pin in _pins) {
        [self addChild:pin];
    }
}

-(void) loadPins{
    int i = 0;
    
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    for (THPin * pin in lilypad.pins) {
        THBoardPinEditable * pinEditable = [[THBoardPinEditable alloc] init];
        pinEditable.simulableObject = pin;
        
        pinEditable.position = ccpAdd(ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f), kLilypadPinPositions[i]);
        pinEditable.position = ccpAdd(pinEditable.position, ccp(pinEditable.contentSize.width/2.0f, pinEditable.contentSize.height/2.0f));
        [_pins addObject:pinEditable];
        i++;
    }
    
    [self addPins];
}

-(id) init{
    self = [super init];
    if(self){
        _pins = [NSMutableArray array];
        
        THLilyPad * lilyPad = [[THLilyPad alloc] init];
        self.simulableObject = lilyPad;
        
        [self loadLilypad];
        [self loadPins];
        
        self.minusPin.highlightColor = kMinusPinHighlightColor;
        self.plusPin.highlightColor = kPlusPinHighlightColor;
        
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        self.pins = [decoder decodeObjectForKey:@"pins"];
        
        [self loadLilypad];
        [self addPins];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.pins forKey:@"pins"];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THLilypadProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(NSInteger) numberOfDigitalPins{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    return lilypad.numberOfDigitalPins;
}

-(NSInteger) numberOfAnalogPins{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    return lilypad.numberOfAnalogPins;
}

-(THBoardPinEditable*) digitalPinWithNumber:(NSInteger) number{
    
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    NSInteger idx = [lilypad pinIdxForPin:number ofType:kPintypeDigital];
    if(idx >= 0){
        return _pins[idx];
    }
    return nil;
}

-(THBoardPinEditable*) analogPinWithNumber:(NSInteger) number{
    THLilyPad * lilypad = (THLilyPad*) self.simulableObject;
    NSInteger idx = [lilypad pinIdxForPin:number ofType:kPintypeAnalog];
    if(idx >= 0){
        return _pins[idx];
    }
    return nil;
}

-(THPinEditable*) minusPin{
    return [_pins objectAtIndex:5];
}

-(THPinEditable*) plusPin{
    return [_pins objectAtIndex:6];
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

-(void) removeFromWorld{
    
}

-(void) prepareToDie{
    for (THBoardPinEditable * pin in self.pins) {
        [pin prepareToDie];
    }
    self.pins = nil;
    [super prepareToDie];
}

-(void) willStartSimulation{
    [self schedule:@selector(updatePins) interval:1.0f];
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Lilypad";
}
@end
