//
//  THOutputEditable.h
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "TFEditableObject.h"

@interface THOutputEditable : TFEditableObject

-(void) connectTop:(TFDataType) type;
-(void) connectBot:(TFDataType) type;
-(void) deleteTop;
-(void) deleteBot;

@property (nonatomic) id value;
@property (nonatomic, readwrite) BOOL topConnected;
@property (nonatomic, readwrite) BOOL botConnected;
@property (nonatomic) TFDataType topType;
@property (nonatomic) TFDataType botType;
@property (nonatomic) TFDataType firstType;

@end
