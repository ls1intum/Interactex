//
//  THGestureLayer.m
//  TangoHapps
//
//  Created by Timm Beckmann on 18/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGestureLayer.h"

@implementation THGestureLayer

-(id) init{
    
    self = [super init];
    if(self){
        self.shouldRecognizePanGestures = YES;
        
        _zoomableLayer = [CCLayer node];
        [self addChild:_zoomableLayer z:-10];
        
    }
    return self;
}

-(void) show {
    /*_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.tag = 1;
    _closeButton.frame = CGRectMake(25, 140, 280.f, 40.f);
    UIImage *airButton = [UIImage imageNamed:@"gesture.png"];
    [_closeButton setBackgroundImage:airButton forState:UIControlStateNormal];*/
    
    
    [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    TFLayer * layer = [THDirector sharedDirector].currentLayer;
    [layer willDisappear];
    _oldLayer = layer;
    layer = self;
    [layer willAppear];
    
    
    CCScene * scene = [CCScene node];
    [scene addChild:layer];
    
    [[CCDirector sharedDirector] replaceScene:scene];
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project addGestureLayer:self];
}

-(void) hide {
    [self willDisappear];
    [_oldLayer willAppear];
    
    CCScene * scene = [CCScene node];
    [scene addChild:_oldLayer];
    
    [[CCDirector sharedDirector] replaceScene:scene];
    NSLog(@"hide Layer");
}

@end
