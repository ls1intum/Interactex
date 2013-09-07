//
//  THBoolValueEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THBoolValueEditable.h"
#import "THBoolValue.h"
#import "THBoolvalueProperties.h"

@implementation THBoolValueEditable

@dynamic value;

CGSize const kBoolValueLabelSize = {80,30};

-(void) loadValue{
    self.sprite = [CCSprite spriteWithFile:@"value.png"];
    [self addChild:self.sprite];
    
    [self reloadLabel];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THBoolValue alloc] init];
        
        [self loadValue];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadValue];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THBoolValueEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THBoolValueProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) reloadLabel{
    [_label removeFromParentAndCleanup:YES];
    NSString * text = [NSString stringWithFormat:@"%d",self.value];
    
    _label = [CCLabelTTF labelWithString:text dimensions:kBoolValueLabelSize hAlignment:NSTextAlignmentCenter vAlignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:15];
    
    _label.position = ccp(25,20);
    [self addChild:_label];
    
    _displayedValue = self.value;
    
}

-(void) update{
    if(self.value != _displayedValue){
        [self reloadLabel];
    }
}

-(BOOL) value{
    THBoolValue * value = (THBoolValue*) self.simulableObject;
    return value.value;
}

-(void) setValue:(BOOL) val{
    THBoolValue * value = (THBoolValue*) self.simulableObject;
    value.value = val;
    [self reloadLabel];
}

-(NSString*) description{
    return @"Bool Value";
}


@end
