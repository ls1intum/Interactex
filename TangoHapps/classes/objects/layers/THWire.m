//
//  THWire.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THWire.h"

@implementation THWireNode
@end

@implementation THWire

@synthesize p1 = _p1;
@synthesize p2 = _p2;

-(id)initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2 {
    self = [super init];
    if (self) {
        self.color = kConnectionLineDefaultColor;
        self.obj1 = obj1;
        self.obj2 = obj2;
        
        nodes = [NSMutableArray array];
        
        THWireNode * node = [[THWireNode alloc] init];
        CGPoint position = ccp((self.p1.x + self.p2.x) / 2.0f, (self.p1.y + self.p2.y) / 2.0f);
        node.point = position;
        [self addNode:node];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if(self){
        self.obj1 = [decoder decodeObjectForKey:@"obj1"];
        self.obj2 = [decoder decodeObjectForKey:@"obj2"];
        self.p2 = [decoder decodeCGPointForKey:@"p2"];
        NSInteger red = [decoder decodeIntegerForKey:@"colorR"];
        NSInteger green = [decoder decodeIntegerForKey:@"colorG"];
        NSInteger blue = [decoder decodeIntegerForKey:@"colorB"];
        self.color = ccc3(red, green, blue);
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.obj1 forKey:@"obj1"];
    [coder encodeObject:self.obj2 forKey:@"obj2"];
    [coder encodeCGPoint:self.p2 forKey:@"p2"];
    [coder encodeInt:self.color.r forKey:@"colorR"];
    [coder encodeInt:self.color.g forKey:@"colorG"];
    [coder encodeInt:self.color.b forKey:@"colorB"];
}

#pragma mark - Drawing

-(void) startDrawingSelectedLines{
    
    glColor4ub(kWireDefaultHighlightColor.r,kWireDefaultHighlightColor.g, kWireDefaultHighlightColor.b, 255);
    
    glLineWidth(kLineWidthSelected);
}

-(void) startDrawingNormalLines{
    
    glColor4ub(self.color.r, self.color.g, self.color.b, 255);
    glLineWidth(kLineWidthNormal);
}

-(void) drawLineSegmentBetween:(CGPoint) p1 and:(CGPoint) p2{
    
     ccDrawLine(p1, p2);
}

-(void) drawLineSegments{
    
    CGPoint currentPoint = self.p1;
    CGPoint nextPoint = self.p2;
    
    if(nodes.count > 0){
        THWireNode * node = [nodes objectAtIndex:0];
        nextPoint = node.point;
    }
    
    [self drawLineSegmentBetween:currentPoint and:nextPoint];
    
    for (int i = 1; i < nodes.count; i++) {
        currentPoint = nextPoint;
        THWireNode * node = [nodes objectAtIndex:i];
        nextPoint = node.point;
        [self drawLineSegmentBetween:currentPoint and:nextPoint];
    }
    
    if(nodes.count > 0){
        [self drawLineSegmentBetween:nextPoint and:self.p2];
    }
}

-(void) drawNodes{
    
    glColor4ub(kWireNodeColor.r, kWireNodeColor.g, kWireNodeColor.b, 255);
    
    
    for (THWireNode * node in nodes) {
        ccDrawCircle(node.point, kWireNodeRadius, 0, 30, NO);
    }
}

-(void) draw{
    if(self.selected){
        [self startDrawingSelectedLines];
    } else {
        [self startDrawingNormalLines];
    }
    
    CGPoint p1 = self.p1;
    CGPoint p2 = self.p2;
    
    [self drawLineSegments];
    [self drawNodes];
    
    ccDrawCircle(p1, 3, 0, 5, NO);
    ccDrawCircle(p2, 3, 0, 5, NO);
}

#pragma mark - Properties

-(CGPoint)p1{
    if(self.obj1 == nil)
        return _p1;
    return self.obj1.center;
}

-(CGPoint)p2{
    if(self.obj2 == nil)
        return _p2;
    return self.obj2.center;
}

-(void) setP1:(CGPoint) pos{
    _p1 = pos;
}

-(void) setP2:(CGPoint) pos{
    _p2 = pos;
}

#pragma mark - Nodes

-(void) addNode:(THWireNode*) node{
    [nodes addObject:node];
}
-(void) removeNode:(THWireNode*) node{
    [nodes removeObject:node];
}

-(THWireNode*) nodeAtPosition:(CGPoint) position{
    for (THWireNode * node in nodes) {
        if(ccpDistance(node.point,position) < kWireNodeRadius){
            return node;
        }
    }
    return nil;
}

@end
