//
//  THClotheObjectEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//


@class THClotheObject;
@class THElementPinEditable;

@interface THClotheObjectEditableObject : TFEditableObject
{
    CCSprite * _sewedSprite;
}

-(void) updateToPinValue;

@property (nonatomic) THHardwareType type;
@property (nonatomic) BOOL pinned;
@property (nonatomic, readonly) NSMutableArray * pins;
@property (nonatomic) BOOL isInputObject;
@property (nonatomic, readonly) NSArray * hardwareProblems;
@property (nonatomic) THClothe * attachedToClothe;

-(THElementPinEditable*) pinAtPosition:(CGPoint) position;

-(void) addPinChilds;
-(void) loadPins;

-(void) drawPinConnections;

-(BOOL) isInputObject;

@end
