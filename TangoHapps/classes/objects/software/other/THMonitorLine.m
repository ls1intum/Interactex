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

-(void) addPointWithX:(float) x y:(float) y{
    
    if(self.points.count > 1){
        
        CGRect rect = self.view.frame;
        
        if(x < rect.origin.x){
            x = rect.origin.x;
        } else if(x > rect.size.width){
            x = rect.origin.x + rect.size.width;
        }
        if(y < rect.origin.y){
            y = rect.origin.y;
        } else if(y > rect.size.height){
            y = rect.origin.y + rect.size.height;
        }
        
        Point2D * previousPoint = [self.points objectAtIndex:self.points.count-1];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(previousPoint.x, previousPoint.y)];
        [path addLineToPoint:CGPointMake(x, y)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = self.color;
        shapeLayer.path = [path CGPath];
        shapeLayer.lineWidth = 2.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:shapeLayer];
    }
    
    Point2D * point = [[Point2D alloc] init];
    point.x = x;
    point.y = y;
    
    [self.points addObject:point];
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
    
    float dx = 10;
    NSInteger removeUntilIndex = [self moveVerticesLeftBy:dx];
    
    [self removeVerticesUntilIndex:removeUntilIndex];
    
    /*
     for (int i = 0; i < kMonitorVerticesLength; i++) {
     printf("(%.1f %.1f %.1f)  ",vertices[i].x,vertices[i].y,vertices[i].z);
     }
     printf("\n");*/
}

@end
