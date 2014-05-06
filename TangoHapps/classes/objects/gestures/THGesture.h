//
//  THGestures.h
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THGestureComponentEditableObject.h"

@class THGestureLayer;

@interface THGesture : THGestureComponentEditableObject {
    
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSMutableArray * attachments;
@property (nonatomic, strong) CCLayerColor * layer;
@property (nonatomic, strong) CCSprite * closeButton;
@property (nonatomic, readwrite) BOOL isOpen;

-(id) initWithName:(NSString*) name;
-(void) attachGestureObject:(THGestureComponentEditableObject*) object;
-(void) deattachGestureObject:(THGestureComponentEditableObject*) object;
-(void) openClose;


@end