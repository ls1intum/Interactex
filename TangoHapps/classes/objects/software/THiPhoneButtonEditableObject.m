//
//  THiPhoneButtonEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneButtonEditableObject.h"
#import "THiPhoneButton.h"
#import "THiPhoneButtonProperties.h"

@implementation THiPhoneButtonEditableObject
@dynamic text;

-(void) loadButtonEditable{
    
    self.contentSize = CGSizeMake(kiPhoneButtonDefaultSize.width, kiPhoneButtonDefaultSize.height);
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THiPhoneButton alloc] init];
        
        THiPhoneButton * button = (THiPhoneButton*) self.simulableObject;
        button.width = 100;
        button.height = 50;
        
        [self loadButtonEditable];
        
        self.text = @"Button";
        self.canChangeBackgroundColor = NO;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    [self loadButtonEditable];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}


#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THiPhoneButtonProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setText:(NSString *)text{
    
    THiPhoneButton * button = (THiPhoneButton*) self.simulableObject;
    button.text = text;
}

-(NSString*) text{
    THiPhoneButton * button = (THiPhoneButton*) self.simulableObject;
    return button.text;
}

-(NSString*) description{
    return @"iButton";
}

@end
