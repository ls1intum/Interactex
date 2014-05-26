//
//  THGesture.m
//  TangoHapps
//
//  Created by Timm Beckmann on 26.05.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGesture.h"

@implementation THGesture

-(void) load{
    
    _attachments = [NSMutableArray array];
    
    TFProperty * property1 = [TFProperty propertyWithName:@"value1" andType:kDataTypeAny];
    self.properties = [NSMutableArray arrayWithObjects:property1,nil];
    
    TFMethod * method1 =  [TFMethod methodWithName:@"method1"];
    self.methods = [NSMutableArray arrayWithObjects:method1, nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventTriggered];
    self.events = [NSMutableArray arrayWithObjects:event1, nil];
}

-(id) init{
    self = [super init];
    if(self){
        [self load];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self load];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

}

-(id)copyWithZone:(NSZone *)zone {
    THGesture * copy = [super copyWithZone:zone];
    
    [copy load];
    
    return copy;
}

-(void) attachGestureObject:(TFEditableObject*) object{
    [_attachments addObject:object];
}

-(void) deattachGestureObject:(TFEditableObject*) object{
    [_attachments removeObject:object];
}

-(void) visible {
    for (TFEditableObject* obj in _attachments) {
        obj.visible = true;
    }
}

-(void) invisible {
    for (TFEditableObject* obj in _attachments) {
        obj.visible = false;
    }
}

-(void) emptyAttachments {
    _attachments = nil;
}

-(void) handleEvents {
    
}


@end
