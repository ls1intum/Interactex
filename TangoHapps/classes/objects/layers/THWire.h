//
//  THWire.h
//  TangoHapps
//
//  Created by Juan Haladjian on 8/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THWire;

@interface THWireNode : TFEditableObject
    //@property (nonatomic) CGPoint point;
    @property (nonatomic, weak) THWire * wire;
@end

@interface THWire : TFEditableObject {
}

@property(nonatomic, weak) TFEditableObject * obj1;
@property(nonatomic, weak) TFEditableObject * obj2;
@property(nonatomic) CGPoint p1;
@property(nonatomic) CGPoint p2;
@property(nonatomic) BOOL selected;
@property(nonatomic) ccColor3B color;
@property(nonatomic, strong) NSMutableArray * nodes;

-(id)initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2;
-(void) addNode:(THWireNode*) node;
-(void) addMiddleNode;
-(void) removeNode:(THWireNode*) node;
-(void) removeAllNodes;
-(THWireNode*) nodeAtPosition:(CGPoint) position;
-(void) draw;

@end
