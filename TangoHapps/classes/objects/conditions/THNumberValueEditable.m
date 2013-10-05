//
//  THValueEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/16/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THNumberValueEditable.h"
#import "THNumberValue.h"
#import "THValueProperties.h"

@implementation THNumberValueEditable
@dynamic value;

CGSize const kLabelSize = {80,30};

-(void) loadValue{
    self.sprite = [CCSprite spriteWithFile:@"value.png"];
    [self addChild:self.sprite];
    
    [self reloadLabel];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THNumberValue alloc] init];

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
    THNumberValueEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THValueProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) reloadLabel{
    [_label removeFromParentAndCleanup:YES];
    NSString * text = [NSString stringWithFormat:@"%.2f",self.value];
    _label = [CCLabelTTF labelWithString:text fontName:kSimulatorDefaultFont fontSize:15 dimensions:kLabelSize hAlignment:kCCVerticalTextAlignmentCenter];
    
    //_label = [CCLabelTTF labelWithString:text dimensions:kLabelSize alignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:15];
    _label.position = ccp(25,20);
    [self addChild:_label];
    
    _displayedValue = self.value;
    
}

-(void) update{
    if(fabs(self.value - _displayedValue) > 0.1){
        [self reloadLabel];
    }
}

-(float) value{
    THNumberValue * value = (THNumberValue*) self.simulableObject;
    return value.value;
}

-(void) setValue:(float)v{
    THNumberValue * value = (THNumberValue*) self.simulableObject;
    value.value = v;
    [self reloadLabel];
}

-(NSString*) description{
    return @"Number";
}

@end
