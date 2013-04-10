//
//  THLabelEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLabelEditableObject.h"
#import "THLabel.h"
#import "THLabelProperties.h"

@implementation THLabelEditableObject
@dynamic text;

-(void) loadLabel{
    
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THLabel alloc] init];
                
        self.text = @"Label";
        [self loadLabel];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    [self loadLabel];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THLabelProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Properties

-(void) setText:(NSString *)text{
    
    THLabel * label = (THLabel*) self.simulableObject;
    label.text = text;
}

-(NSString*) text{
    THLabel * label = (THLabel*) self.simulableObject;
    return label.text;
}

-(NSString*) description{
    return @"Label";
}

@end
