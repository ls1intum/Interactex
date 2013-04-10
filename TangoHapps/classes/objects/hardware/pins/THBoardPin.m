//
//  THBoardPin.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THBoardPin.h"
#import "THElementPin.h"
#import "THClotheObject.h"

@implementation THBoardPin
@dynamic acceptsManyPins;

+(id) pinWithPinNumber:(NSInteger) pinNumber andType:(THPinType) type{
    return [[THBoardPin alloc] initWithPinNumber:pinNumber andType:type];
}

-(id) initWithPinNumber:(NSInteger) pinNumber andType:(THPinType) type{
    
    self = [super init];
    if(self){
        self.number = pinNumber;
        self.type = type;
        self.mode = kPinModeUndefined;
        
        _attachedPins = [NSMutableArray array];
    }
    return self;
    
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    _attachedPins = [decoder decodeObjectForKey:@"attachedPins"];
    _number = [decoder decodeIntForKey:@"number"];
    _type = [decoder decodeIntForKey:@"pinType"];
    _mode = [decoder decodeIntForKey:@"mode"];
    _isPWM = [decoder decodeBoolForKey:@"isPWM"];

    return self;
}

-(id) init{
    self = [super init];
    if(self){
        _attachedPins = [NSMutableArray array];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.attachedPins forKey:@"attachedPins"];
    [coder encodeInt:self.number forKey:@"number"];
    [coder encodeInt:self.type forKey:@"pinType"];
    [coder encodeInt:self.mode forKey:@"mode"];
    [coder encodeBool:self.isPWM forKey:@"isPWM"];
}

-(id)copyWithZone:(NSZone *)zone {
    THBoardPin * copy = [super copyWithZone:zone];
    copy.number = self.number;
    copy.type = self.type;
    copy.mode = self.mode;
    
    return copy;
}

#pragma mark - Methods

-(BOOL) acceptsManyPins{
    return (self.type == kPintypeMinus || self.type == kPintypePlus);
}

-(void) notifyPinsNewValue:(NSInteger)value {
    
    for (THElementPin * pin in self.attachedPins) {
        [pin.hardware handlePin:self changedValueTo:value];
    }
}

-(void) setCurrentValue:(NSInteger)value{
    if(value != self.currentValue){
        self.hasChanged = YES;
        _currentValue = value;
        [self notifyPinsNewValue:value];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPinValueChanged object:self];
    }
}

-(void) attachPin:(THElementPin*) pin{
    if(!self.acceptsManyPins && _attachedPins.count == 1){
        THElementPin * pin = [_attachedPins objectAtIndex:0];
        [pin deattach];
        
        [_attachedPins removeAllObjects];
    }
    
    if(self.type != kPintypeMinus && self.type != kPintypePlus && self.mode == kPinModeUndefined){
        self.mode = pin.defaultBoardPinMode;
    }
    
    [_attachedPins addObject:pin];
}

-(void) deattachPin:(THElementPin*) pin{
    [_attachedPins removeObject:pin];
    
    if(_attachedPins.count == 0){
        self.mode = kPinModeUndefined;
    }
}

-(void) prepareToDie{
    _attachedPins = nil;
}

-(NSString*) description{
    
    NSString * text;
    if(self.type == kPintypeMinus || self.type == kPintypePlus){
        text = [NSString stringWithFormat:@"(%@) pin",kPinTexts[self.type]];
    } else {
        text = [NSString stringWithFormat:@"pin %d (%@)",self.number, kPinTexts[self.type]];
    }
    
    return text;
}

@end


