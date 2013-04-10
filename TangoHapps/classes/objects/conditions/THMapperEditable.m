//
//  THMapperEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMapperEditable.h"
#import "THMapper.h"
#import "THMapperProperties.h"

@implementation THMapperEditable
@dynamic min;
@dynamic max;
@dynamic value;
@dynamic function;

-(void) load{
    self.sprite = [CCSprite spriteWithFile:@"mapper.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THMapper alloc] init];
        
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
    THMapperEditable * copy = [super copyWithZone:zone];
    
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THMapperProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) update{
    
}

-(float) min{
    THMapper * mapper = (THMapper*) self.simulableObject;
    return mapper.min;
}

-(void) setMin:(float)min{
    THMapper * mapper = (THMapper*) self.simulableObject;
    mapper.min = min;
}

-(float) max{
    THMapper * mapper = (THMapper*) self.simulableObject;
    return mapper.max;
}

-(void) setMax:(float)max{
    THMapper * mapper = (THMapper*) self.simulableObject;
    mapper.max = max;
}

-(float) value{
    THMapper * mapper = (THMapper*) self.simulableObject;
    return mapper.value;
}

-(void) setValue:(float)v{
    THMapper * mapper = (THMapper*) self.simulableObject;
    mapper.value = v;
}

-(THLinearFunction*) function{
    THMapper * mapper = (THMapper*) self.simulableObject;
    return mapper.function;
}

-(void) setFunction:(THLinearFunction*) function{
    THMapper * mapper = (THMapper*) self.simulableObject;
    mapper.function = function;
}

-(NSString*) description{
    return @"Value";
}

@end
