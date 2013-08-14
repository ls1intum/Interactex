//
//  THElementPin.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/15/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THElementPin.h"
#import "THBoardPin.h"
#import "THClotheObject.h"

@implementation THElementPin

@dynamic connected;


#pragma mark - Construction

+(id) pinWithType:(THElementPinType) type{
    return [[THElementPin alloc] initWithType:type];
}

-(id) initWithType:(THElementPinType) type{
    self = [super init];
    if(self){
        self.type = type;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    _attachedToPin = [decoder decodeObjectForKey:@"attachedToPin"];
    _type = [decoder decodeIntegerForKey:@"type"];
    _hardware = [decoder decodeObjectForKey:@"hardware"];
    _defaultBoardPinMode = [decoder decodeIntegerForKey:@"defaultBoardPinMode"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_attachedToPin forKey:@"attachedToPin"];
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeObject:_hardware forKey:@"hardware"];
    [coder encodeInteger:_defaultBoardPinMode forKey:@"defaultBoardPinMode"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THElementPin * copy = [super copyWithZone:zone];
    copy.type = self.type;
    
    //[copy attachToPin:self.attachedToPin];
    
    return copy;
}

#pragma mark - Methods

/*
-(THPinMode) defaultBoardPinMode{
    if(self.type == kElementPintypeAnalog){
        return kPinModeAnalogInput;
    } else {
        if(self.hardware)
        if(self.hardware.isInputObject){
            return kPinModeDigitalInput;
        } else {
            return kPinModeDigitalOutput;
        }
    }
}*/

-(BOOL) connected{
    return self.attachedToPin != nil;
}

-(void) attachToPin:(THBoardPin*) pin{
    _attachedToPin = pin;
}

-(void) deattach{
    _attachedToPin = nil;
}

-(void) prepareToDie{
    _attachedToPin = nil;
    [super prepareToDie];
}

-(NSString*) shortDescription{
    
    return [NSString stringWithFormat:@"pin %@",kElementPinTexts[self.type]];
}

-(NSString*) description{
    NSString * text = [NSString stringWithFormat:@"(%@), ",kElementPinTexts[self.type]];
    if(self.connected){
        text = [NSString stringWithFormat:@"%@ connected to %@",text, self.attachedToPin.description];
    } else {
        text = [text stringByAppendingString:@"not attached"];
    }
    return text;
}

@end
