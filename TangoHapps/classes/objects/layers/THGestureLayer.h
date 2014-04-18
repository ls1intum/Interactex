//
//  THGestureLayer.h
//  TangoHapps
//
//  Created by Timm Beckmann on 18/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "TFLayer.h"

@class THEditorToolsViewController;

@interface THGestureLayer : TFLayer

@property (nonatomic) CCLayer * zoomableLayer;
@property (nonatomic) float zoomLevel;
@property (nonatomic) CGPoint displacement;
@property (nonatomic) THGesture * parent;

@property (nonatomic) TFLayer * oldLayer;

@property (strong, nonatomic) UIButton * closeButton;

-(void) show;
-(void) hide;

@end

