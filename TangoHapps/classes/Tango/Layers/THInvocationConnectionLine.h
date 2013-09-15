//
//  THInvocationConnectionLine.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFConnectionLine;

#define THInvocationConnectionLineNumStates 2

typedef enum  {
    THInvocationConnectionLineStateIncomplete,
    THInvocationConnectionLineStateComplete
} THInvocationConnectionLineState;

@interface THInvocationConnectionLine : TFEditableObject
{
    CCSprite * _invocationStateSprite;
}


@property(nonatomic) TFEditableObject * obj1;
@property(nonatomic) TFEditableObject * obj2;
@property(nonatomic) TFMethodInvokeAction * action;

@property(nonatomic) BOOL shouldAnimate;

@property (nonatomic, strong) TFConnectionLine * connectionLine;
@property (nonatomic) NSInteger numParameters;
@property (nonatomic) THInvocationConnectionLineState state;
@property (nonatomic) TFDataType parameterType;

-(id) initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2;
-(void) reloadSprite;
-(void) startShining;

@end
