//
//  THGestureComponentEditableObject.h
//  TangoHapps
//
//  Created by Timm Beckmann on 06.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THGestureComponent;
@class THElementPinEditable;

@interface THGestureComponentEditableObject : TFEditableObject

-(void) updateToPinValue;

@property (nonatomic, copy) NSString * objectName;
@property (nonatomic) THHardwareType type;
@property (nonatomic, readonly) NSMutableArray * pins;
@property (nonatomic) BOOL isInputObject;
@property (nonatomic, readonly) NSArray * hardwareProblems;
@property (nonatomic, weak) THGesture * attachedToGesture;
@property (nonatomic, readonly) THElementPinEditable * mainPin;

-(THElementPinEditable*) pinAtPosition:(CGPoint) position;
-(void) addPinChilds;
-(void) loadPins;
-(BOOL) isInputObject;
-(void) autoroutePlusAndMinusPins;
-(void) autoroute;
-(void) handleBoardRemoved:(THBoardEditable *)board;

@property (nonatomic, strong) CCLabelTTF * nameLabel;

@end
