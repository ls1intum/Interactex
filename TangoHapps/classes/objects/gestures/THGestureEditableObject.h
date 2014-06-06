//
//  THGestures.h
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THHardwareComponentEditableObject.h"

@class THGestureLayer;

@interface THGestureEditableObject : THHardwareComponentEditableObject{
    
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) CCLayerColor * layer;
//@property (nonatomic, strong) CCSprite * closeButton;
@property (nonatomic, readwrite) BOOL isOpen;
-(id) initWithName:(NSString*) name;
-(void) attachGestureObject:(TFEditableObject*) object;
-(void) deattachGestureObject:(TFEditableObject*) object;
-(void) openClose;
-(NSMutableArray*) getAttachments;
-(void) outputAmountChanged;


@end