//
//  THMonitorLine2.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/6/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THMonitorLine.h"
float const kMonitorPixelsToSeconds = 5;

@implementation Point2D


@end

@implementation THMonitorLine

-(id) initWithColor:(CGColorRef) aColor{
    
    self = [super init];
    
    if(self){
        
        self.color = aColor;
        self.points = [NSMutableArray array];
    }
    
    return self;
}

-(void) addPoint:(CGPoint) point{
    
    CGRect rect = self.view.bounds;
    
    float maxX = rect.size.width;
    float minX = 0;
    
    float maxY = rect.size.height;
    float minY = 0;
    
    //NSLog(@"enters: %f ,max %f min %f",point.y, maxY, minY);
    //NSLog(@"enters: %f ,max %f min %f",point.x, maxX, minX);
    
    if(point.x < minX){
        point.x = minX;
    } else if(point.x > maxX){
        point.x = maxX;
    }
    if(point.y < minY){
        point.y = minY;
    } else if(point.y > maxY){
        point.y = maxY;
    }
    
    Point2D * myPoint = [[Point2D alloc] init];
    myPoint.x = point.x;
    myPoint.y = point.y;
    
    [self.points addObject:myPoint];
    
    if(self.points.count >= 2){
        
        Point2D * previousPoint = [self.points objectAtIndex:self.points.count-2];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(previousPoint.x, previousPoint.y)];
        [path addLineToPoint:CGPointMake(point.x, point.y)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = self.color;
        shapeLayer.path = [path CGPath];
        shapeLayer.lineWidth = 2.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:shapeLayer];
    }
}

-(NSInteger) moveVerticesLeftBy:(float) dx{
    
    NSInteger firstIdx = -1;
    
    for (int i = 0 ; i < self.points.count ; i++){
        
        Point2D * point = [self.points objectAtIndex:i];
        
        point.x -= dx;
        /*
        if(i == 0){
            NSLog(@"%f",point.x);
        }
        */
        if(point.x < 100){
            firstIdx = i;
        }
    }
    
    for (CAShapeLayer * layer in self.view.layer.sublayers) {
        CGPoint origin = layer.frame.origin;
        origin.x -= dx;
        CGRect rect = layer.frame;
        rect.origin = origin;
        layer.frame = rect;
    }
    
    return firstIdx;
}

-(void) removeVerticesUntilIndex:(NSInteger) index{
    
    if(index >= 0){
        
        for (int i = 0; i <= index; i++) {
            [self.points removeObjectAtIndex:0];
        }
        
        for (int i = 0 ; i <= index ; i++){
            CALayer * layer = [self.view.layer.sublayers objectAtIndex:0];
            [layer removeFromSuperlayer];
        }
    }
}

-(void) update:(float) dt{
    
    float dx = 3;
    
    NSInteger removeUntilIndex = [self moveVerticesLeftBy:dx];
    [self removeVerticesUntilIndex:removeUntilIndex];
    
    /*
     for (int i = 0; i < kMonitorVerticesLength; i++) {
     printf("(%.1f %.1f %.1f)  ",vertices[i].x,vertices[i].y,vertices[i].z);
     }
     printf("\n");*/
}

@end
