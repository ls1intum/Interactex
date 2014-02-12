/*
THMonitorLine.m
Interactex Designer

Created by Juan Haladjian on 11/06/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

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

-(void) removeAllPoints{
    [self.points removeAllObjects];
    
    self.view.layer.sublayers = nil;
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
