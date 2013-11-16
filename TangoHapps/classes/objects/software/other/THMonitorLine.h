//
//  THMonitorLine2.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Point2D : NSObject

@property (nonatomic) float x;
@property (nonatomic) float y;

@end

@interface THMonitorLine : NSObject
{
}

@property (nonatomic) CGColorRef color;
@property (nonatomic, weak) UIView * view;
@property (nonatomic) NSMutableArray * points;

-(id) initWithColor:(CGColorRef) aColor;
-(void) addPoint:(CGPoint) point;
-(void) removeAllPoints;

-(void) update:(float) dt;

@end
