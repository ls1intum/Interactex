//
//  THLilypadEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/22/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLilypadNumberOfPins 22

@class THBoardPinEditable;
@class THElementPinEditable;

@interface THLilyPadEditable : TFEditableObject {
    THBoardPinEditable * _highlightedPin;
}

@property (nonatomic, readonly) NSInteger numberOfDigitalPins;
@property (nonatomic, readonly) NSInteger numberOfAnalogPins;
@property (nonatomic, strong) NSMutableArray * pins;

/*
-(void) attachElementPin:(THElementPinEditable*) elementPin atPin:(NSInteger) pinNumber ofType:(THPinType) type;
*/
-(NSInteger) pinNumberAtPosition:(CGPoint) position;
-(THBoardPinEditable*) pinAtPosition:(CGPoint) position;

-(THBoardPinEditable*) digitalPinWithNumber:(NSInteger) number;
-(THBoardPinEditable*) analogPinWithNumber:(NSInteger) number;
-(THBoardPinEditable*) minusPin;
-(THBoardPinEditable*) plusPin;

@end