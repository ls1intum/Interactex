//
//  THGesture.h
//  TangoHapps
//
//  Created by Timm Beckmann on 26.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THHardwareComponent.h"

@interface THGesture : THHardwareComponent

@property (nonatomic, strong) NSMutableArray * attachments;
@property (nonatomic, readwrite) BOOL isOpen;

-(void) attachGestureObject:(TFEditableObject*) object;
-(void) deattachGestureObject:(TFEditableObject*) object;
-(void) visible;
-(void) invisible;
-(void) emptyAttachments;
-(void) handleEvents;

@end
