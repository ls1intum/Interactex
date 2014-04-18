//
//  THGestures.h
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THHardwareComponentEditableObject;
@class THGestureLayer;

@interface THGesture : TFEditableObject {
    
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSMutableArray * attachments;
@property (nonatomic, strong) THGestureLayer * layer;

-(id) initWithName:(NSString*) name;
-(void) attachGestureObject:(THHardwareComponentEditableObject*) object;
-(void) deattachGestureObject:(THHardwareComponentEditableObject*) object;
-(void) open;


@end