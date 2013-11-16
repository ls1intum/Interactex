//
//  THBoardEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObject.h"

@class THBoardPinEditable;

@interface THBoardEditable : TFEditableObject
{
    
}

@property (nonatomic, readonly) NSInteger numberOfDigitalPins;
@property (nonatomic, readonly) NSInteger numberOfAnalogPins;
@property (nonatomic, strong) NSMutableArray * pins;

-(THBoardPinEditable*) minusPin;
-(THBoardPinEditable*) plusPin;

-(THBoardPinEditable*) sclPin;
-(THBoardPinEditable*) sdaPin;

-(THBoardPinEditable*) pinAtPosition:(CGPoint) position;

-(NSInteger) pinNumberAtPosition:(CGPoint) position;
-(THBoardPinEditable*) digitalPinWithNumber:(NSInteger) number;
-(THBoardPinEditable*) analogPinWithNumber:(NSInteger) number;

@end
