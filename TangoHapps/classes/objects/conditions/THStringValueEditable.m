//
//  THStringValueEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THStringValueEditable.h"
#import "THStringValue.h"
#import "THStringValueProperties.h"

@implementation THStringValueEditable

@dynamic value;

CGSize const kStringValueLabelSize = {100,30};

-(void) loadValue{
    self.sprite = [CCSprite spriteWithFile:@"value.png"];
    [self addChild:self.sprite];
    
    [self reloadLabel];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THStringValue alloc] init];
        
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
    THStringValueEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THStringValueProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) reloadLabel{
    [_label removeFromParentAndCleanup:YES];

    NSString * text;
    if(self.value == nil){
        text = @"<empty>";
    } else {
        text = [NSString stringWithFormat:@"%@",self.value];
    }
    
    
    _label = [CCLabelTTF labelWithString:text fontName:kSimulatorDefaultFont fontSize:14 dimensions:kStringValueLabelSize hAlignment:NSTextAlignmentCenter];
    _label.position = ccp(25,25);
    [self addChild:_label];
    
    _displayedValue = self.value;
    
}

-(void) update{
    if(![self.value isEqualToString: _displayedValue]){
        [self reloadLabel];
    }
}

-(NSString*) value{
    THStringValue * value = (THStringValue*) self.simulableObject;
    return value.value;
}

-(void) setValue:(NSString*) val{
    THStringValue * value = (THStringValue*) self.simulableObject;
    value.value = [val copy];
    [self reloadLabel];
}

-(NSString*) description{
    return @"String";
}

@end
