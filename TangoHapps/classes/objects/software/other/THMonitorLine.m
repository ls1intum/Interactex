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
    
    NSLog(@"enters: %f ,max %f min %f",point.y,rect.origin.y + rect.size.height/2, rect.origin.y);
    
    if(point.x < rect.origin.x){
        point.x = rect.origin.x;
    } else if(point.x > rect.origin.x + rect.size.width){
        point.x = rect.origin.x + rect.size.width;
    }
    if(point.y < rect.origin.y){
        point.y = rect.origin.y;
    } else if(point.y > rect.origin.y + rect.size.height/2){
        point.y = rect.origin.y + rect.size.height/2;
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
        
        if(point.x < 0){            
            firstIdx = i;
        }
    }
    
    for (CAShapeLayer * layer in self.view.layer.sublayers) {
        CGPoint origin = layer.frame.origin;
        origin.x -=dx;
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
    
    float dx = 1;
    
    NSInteger removeUntilIndex = [self moveVerticesLeftBy:dx];
    [self removeVerticesUntilIndex:removeUntilIndex];
    
    /*
     for (int i = 0; i < kMonitorVerticesLength; i++) {
     printf("(%.1f %.1f %.1f)  ",vertices[i].x,vertices[i].y,vertices[i].z);
     }
     printf("\n");*/
}

@end
