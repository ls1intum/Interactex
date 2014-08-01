//
//  THGestures.h
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THOutputEditable.h"

@interface THGestureEditableObject : TFEditableObject{
    
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * saveName;
@property (nonatomic, strong) CCLayerColor * layer;
@property (nonatomic, readwrite) BOOL isOpen;
@property int outCount;
@property int inCount;
@property (nonatomic, strong) NSMutableArray * inputs;
@property (nonatomic, strong) NSMutableArray * outputs;

-(id) initWithName:(NSString*) name;
-(void) attachGestureObject:(TFEditableObject*) object;
-(void) deattachGestureObject:(TFEditableObject*) object;
-(void) openClose;
-(void) scale:(float) amount;
-(NSMutableArray*) getAttachments;
-(void) outputAmountChanged:(int) count;
-(void) inputAmountChanged:(int) count;
-(void) addOutput;
-(void) deleteOutput;
-(void) attachOutput:(THOutputEditable*) object;
-(void) deattachOutput:(THOutputEditable*) object;
-(void) outputRemoved:(NSNotification*) object;


@end