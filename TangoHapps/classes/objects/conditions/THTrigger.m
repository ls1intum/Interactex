//
//  THTrigger.m
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTrigger.h"

@implementation THTrigger


-(id)init{
    self = [super init];
    if(self) {
        _actions = [NSMutableArray array];
        [self loadTrigger];
    }
    return self;
}

-(void) loadTrigger{
    /*
    TFMethod * method = [TFMethod methodWithName:@"trigger"];
    self.methods = [NSArray arrayWithObject:method];*/
    
    TFEvent * event = [TFEvent eventNamed:kEventTriggered];
    self.events = [NSMutableArray arrayWithObject:event];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _actions =  [decoder decodeObjectForKey:@"actions"];
        [self loadTrigger];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_actions forKey:@"actions"];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THTrigger * copy = [super copyWithZone:zone];
    
    copy.actions = _actions;
    
    return copy;
}

-(void) addAction:(TFAction *) action{
    [_actions addObject:action];
}

-(void) removeAction:(TFAction*) action{
    [_actions removeObject:action];
}

@end
