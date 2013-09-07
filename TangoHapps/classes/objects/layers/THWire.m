//
//  THWire.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THWire.h"
#import "THWireProperties.h"
#import "THCustomEditor.h"

@implementation THWireNode

-(void) draw{
    
    //glColor4ub(kWireNodeColor.r, kWireNodeColor.g, kWireNodeColor.b, 255);
    ccDrawCircle(ccp(0,0), kWireNodeRadius, 0, 30, NO);
}

-(BOOL) testPoint:(CGPoint)point{
    CGPoint global = [self convertToWorldSpace:ccp(0,0)];
    return ccpDistance(global, point) < kWireNodeRadius;
}

@end

@implementation THWire

@synthesize p1 = _p1;
@synthesize p2 = _p2;

-(id)initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2 {
    self = [super init];
    if (self) {
        self.zoomable = YES;
        self.position = ccp(0,0);
        self.color = kConnectionLineDefaultColor;
        self.obj1 = obj1;
        self.obj2 = obj2;
        
        _nodes = [NSMutableArray array];
        
        [self addMiddleNode];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if(self){
        self.zoomable = YES;
        
        self.obj1 = [decoder decodeObjectForKey:@"obj1"];
        self.obj2 = [decoder decodeObjectForKey:@"obj2"];
        self.p2 = [decoder decodeCGPointForKey:@"p2"];
        NSInteger red = [decoder decodeIntegerForKey:@"colorR"];
        NSInteger green = [decoder decodeIntegerForKey:@"colorG"];
        NSInteger blue = [decoder decodeIntegerForKey:@"colorB"];
        self.color = ccc3(red, green, blue);
        
        _nodes = [NSMutableArray array];
        NSArray * nodes = [decoder decodeObjectForKey:@"nodes"];
        
        for (THWireNode * node in nodes) {
            [self addNode:node];
        }
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
    [coder encodeObject:self.nodes forKey:@"nodes"];
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THWireProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Drawing

-(void) startDrawingSelectedLines{
    /*
    float kColorHighlightIncreaseFactor = 1.20f;
    
    float r = MIN(255, self.color.r * kColorHighlightIncreaseFactor);
    float g = MIN(255, self.color.g * kColorHighlightIncreaseFactor);
    float b = MIN(255, self.color.b * kColorHighlightIncreaseFactor);
    
   // glColor4ub(r, g, b, 255);
    */
    glLineWidth(kLineWidthSelected);
}

-(void) startDrawingNormalLines{
    
    //glColor4ub(self.color.r, self.color.g, self.color.b, 255);
    glLineWidth(kLineWidthNormal);
}

-(void) drawLineSegmentBetween:(CGPoint) p1 and:(CGPoint) p2{
    
     ccDrawLine(p1, p2);
}

-(void) drawLineSegments{
    
    CGPoint currentPoint = self.p1;
    CGPoint nextPoint = self.p2;
    
    if(self.nodes.count > 0){
        THWireNode * node = [self.nodes objectAtIndex:0];
        nextPoint = node.position;
    }
    
    [self drawLineSegmentBetween:currentPoint and:nextPoint];
    
    for (int i = 1; i < self.nodes.count; i++) {
        currentPoint = nextPoint;
        THWireNode * node = [self.nodes objectAtIndex:i];
        nextPoint = node.position;
        [self drawLineSegmentBetween:currentPoint and:nextPoint];
    }
    
    if(self.nodes.count > 0){
        [self drawLineSegmentBetween:nextPoint and:self.p2];
    }
}

-(void) drawNodes{
    
    //glColor4ub(kWireNodeColor.r, kWireNodeColor.g, kWireNodeColor.b, 255);
    
    
    for (THWireNode * node in self.nodes) {
        ccDrawCircle(node.position, kWireNodeRadius, 0, 30, NO);
    }
}

-(void) draw{
//    if(self.visible){
        if(self.selected){
            [self startDrawingSelectedLines];
        } else {
            [self startDrawingNormalLines];
        }
        
        
        [self drawLineSegments];
        //[self drawNodes];
        
        ccDrawCircle(self.p1, 3, 0, 5, NO);
        ccDrawCircle(self.p2, 3, 0, 5, NO);
 //   }
}

#pragma mark - Properties
/*
-(void) setShowing:(BOOL)showing{
    for (THWireNode * node in self.nodes) {
        node.visible = showing;
    }
    _showing = showing;
}*/

-(CGPoint)p1{
    if(self.obj1 == nil)
        return _p1;
    
    //THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
    CGPoint pos = [self.obj1 convertToWorldSpace:ccp(0,0)];
    return [self convertToNodeSpace:pos];
}

-(CGPoint)p2{
    if(self.obj2 == nil)
        return _p2;
    
    //return self.obj2.position;
    
    //THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
    CGPoint pos = [self.obj2 convertToWorldSpace:ccp(0,0)];
    return [self convertToNodeSpace:pos];
}

-(void) setP1:(CGPoint) pos{
    _p1 = pos;
}

-(void) setP2:(CGPoint) pos{
    _p2 = pos;
}

#pragma mark - Nodes

-(void) removeNodeObservers{
    for (THWireNode * node in self.nodes) {
        [node removeObserver:self forKeyPath:@"selected"];
    }
}

-(void) addNodeObservers{
    for (THWireNode * node in self.nodes) {
        [node addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) setNodes:(NSMutableArray *)nodes{
    if(_nodes != nodes){
        if(_nodes){
            [self removeNodeObservers];
        }
        
        _nodes = nodes;
        
        [self addNodeObservers];
    }
}

-(void) addMiddleNode{
    
    THWireNode * node = [[THWireNode alloc] init];
    
    CGPoint global1 = [self.obj1 convertToWorldSpace:ccp(0,0)];
    CGPoint global2 = [self.obj2 convertToWorldSpace:ccp(0,0)];
    CGPoint position = ccp((global1.x + global2.x) / 2.0f, (global1.y + global2.y) / 2.0f);
    
    THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
    
    node.position = [editor convertToNodeSpace:position];
    
    [self addNode:node];
}

-(void) addNode:(THWireNode*) node{
    [node addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    node.wire = self;
    [self addChild:node];
    [self.nodes addObject:node];
}

-(void) removeNode:(THWireNode*) node{
    [node removeObserver:self forKeyPath:@"selected"];
    node.wire = nil;
    [self.nodes removeObject:node];
}

-(void) removeAllNodes{
    [self removeNodeObservers];
    for (THWireNode * node in self.nodes) {
        node.wire = nil;
    }
    [self.nodes removeAllObjects];
}

-(THWireNode*) nodeAtPosition:(CGPoint) position{
    for (THWireNode * node in self.nodes) {
        if([node testPoint:position]){
            return node;
        }
    }
    return nil;
}

#pragma mark - Layer

-(void) addToLayer:(TFLayer *)layer{
    [layer addEditableObject:self];
    
    THCustomEditor * editor = (THCustomEditor*) [THDirector sharedDirector].currentLayer;
    self.visible = editor.isLilypadMode;
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

#pragma mark - Node Observer

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"selected"]){
        THWireNode * node = object;
        self.selected = node.selected;
    }
}

#pragma mark - Other

-(void) prepareToDie{
    [self removeAllNodes];
    [super prepareToDie];
    
}
@end
