//
//  THCustomComponentEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 23/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THCustomComponentEditable.h"
#import "THCustomComponent.h"
#import "THCustomComponentProperties.h"

@implementation THCustomComponentEditable

@dynamic name;
@dynamic code;

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THCustomComponent alloc] init];
        
        [self loadCustomComponent];
    }
    return self;
}

-(void) loadCustomComponent{
    
    self.programmingElementType = kProgrammingElementTypeCustomComponent;
    self.acceptsConnections = YES;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        [self loadCustomComponent];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THCustomComponent * copy = [super copyWithZone:zone];
    if(copy){
    }
    return copy;
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObjectsFromArray:[super propertyControllers]];
    [controllers addObject:[THCustomComponentProperties properties]];
    return controllers;
}

-(NSString*) name{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    return customComponent.name;
}

-(void) setName:(NSString *)name{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    customComponent.name = name;
}

-(NSString*) code{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    return customComponent.code;
}

-(void) setCode:(NSString *)code{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    customComponent.code = code;
}

-(id) result{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    return customComponent.result;
}

-(void) execute:(id) param{
    THCustomComponent * customComponent = (THCustomComponent*) self.simulableObject;
    [customComponent execute:param];
}

-(NSString*) description{
    return @"CustomComponent";
}

@end
