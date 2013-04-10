//
//  THAddressBookEditable.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THContactBookEditable.h"
#import "THContactBookProperties.h"
#import "THContactBook.h"

@implementation THContactBookEditable

@dynamic showCallButton;
@dynamic showNextButton;
@dynamic showPreviousButton;

-(void) loadContactBook{
    
    self.canChangeBackgroundColor = NO;
    self.canBeRootView = NO;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THContactBook alloc] init];
        
        [self loadContactBook];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        [self loadContactBook];
    }
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
    [controllers addObject:[THContactBookProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) next{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    [contactBook next];
}

-(void) previous{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    [contactBook previous];
}

-(void) call{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    [contactBook call];
}

-(BOOL) showCallButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    return contactBook.showCallButton;
}

-(void) setShowCallButton:(BOOL)showCallButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    contactBook.showCallButton = showCallButton;
}

-(BOOL) showPreviousButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    return contactBook.showPreviousButton;
}

-(void) setShowPreviousButton:(BOOL)showPreviousButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    contactBook.showPreviousButton = showPreviousButton;
}

-(BOOL) showNextButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    return contactBook.showNextButton;
}

-(void) setShowNextButton:(BOOL)showNextButton{
    THContactBook * contactBook = (THContactBook*) self.simulableObject;
    contactBook.showNextButton = showNextButton;
}

-(NSString*) description{
    return @"ContactBook";
}

@end
