//
//  THBoardPinEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THBoardPinEditable.h"
#import "THBoardPin.h"
#import "THElementPinEditable.h"
#import "THCustomEditor.h"

@implementation THBoardPinEditable

@synthesize attachedPins = _attachedPins;
@dynamic number;
@dynamic type;
@dynamic mode;
@dynamic acceptsManyPins;
@dynamic isPWM;
@dynamic value;

-(id) init{
    self = [super init];
    if(self){
        _attachedPins = [NSMutableArray array];
    }
    return self;
}

-(id) initWithPin:(THBoardPin*) pin{
    self = [super init];
    if(self){
        self.simulableObject = pin;
        _attachedPins = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    
    _attachedPins = [decoder decodeObjectForKey:@"attachedPins"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.attachedPins forKey:@"attachedPins"];
}

#pragma mark - Methods

-(void) setHighlighted:(BOOL)selected{
    if(selected){
        THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
        
        NSString * text = kPinTexts[self.type];
        
        if(self.type == kPintypeAnalog || self.type == kPintypeDigital){

            text = [text stringByAppendingFormat:@" %d",self.number];
        }
        
        _label = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(60, 30) hAlignment:NSTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:15];
        
        //_label = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(60, 30) alignment:NSTextAlignmentCenter fontName:@"Arial Rounded MT Bold" fontSize:20];
        
        CGPoint position = [self convertToWorldSpace:ccp(0,0)];
        _label.position = ccpAdd(position,ccp(0,50));
        
        [editor addChild:_label];
    } else {
        [_label removeFromParentAndCleanup:YES];
        _label = nil;
    }
    
    [super setHighlighted:selected];
}

-(NSInteger) currentValue{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.value;
}

-(void) setCurrentValue:(NSInteger)currentValue{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    pin.value = currentValue;
}

-(BOOL) isPWM{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.isPWM;
}

-(void) setIsPWM:(BOOL) b{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    pin.isPWM = b;
}

-(BOOL) acceptsManyPins{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.acceptsManyPins;
}

-(THPinMode) mode{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.mode;
}

-(THPinType) type{
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.type;
}

-(void) setType:(THPinType)pinType{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    pin.type = pinType;
}

-(NSInteger) number{
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.number;
}

-(void) setNumber:(NSInteger)pinNumber{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    pin.number = pinNumber;
}

-(BOOL) supportsSCL{
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.supportsSCL;
}

-(BOOL) supportsSDA{
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    return pin.supportsSDA;
}

-(void) draw{
    
    //ccDrawCircle(ccp(0,0), kLilypadPinRadius, 0, 15, 0);
    
    
    if(self.highlighted){
        glLineWidth(2);
        if(self.attachedPins.count > 0 && !self.acceptsManyPins){
            ccDrawColor4F(0.82, 0.58, 0.58, 1.0);

        } else {
            ccDrawColor4F(0.12, 0.58, 0.84, 1.0);
        }
        
        ccDrawCircle(ccp(0,0), kLilypadPinRadius, 0, 15, 0);
        
        glLineWidth(1);
        
        ccDrawColor4F(1.0f, 1.0f, 1.0f, 1.0);
    }
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    if(self.type == kPintypeDigital && pin.value == 1){
        
        ccDrawColor4F(0.0f, 1.0f, 0.0f, 1.0);
        ccDrawCircle(ccp(0,0), 10, 0, 10, 0);
    }
}

-(void) attachPin:(THElementPinEditable*) pinEditable{
    if(!self.acceptsManyPins && self.attachedPins.count == 1){
        THElementPinEditable * pin = [self.attachedPins objectAtIndex:0];
        [pin dettachFromPin];
        
        [_attachedPins removeAllObjects];
    }
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    [pin attachPin:(THElementPin*) pinEditable.simulableObject];
    
    [_attachedPins addObject:pinEditable];
}

-(void) deattachPin:(THElementPinEditable*) pinEditable{
    
    THBoardPin * pin = (THBoardPin*) self.simulableObject;
    [pin deattachPin:(THElementPin*)pinEditable.simulableObject];
    
    [_attachedPins removeObject:pinEditable];
    
    [pinEditable dettachFromPin];
}

-(NSString*) description{
    return self.simulableObject.description;
}

-(void) prepareToDie{
    
    [super prepareToDie];
    
    _attachedPins = nil;
}


@end
