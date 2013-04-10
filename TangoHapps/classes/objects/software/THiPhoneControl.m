//
//  THiPhoneControl.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/11/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneControl.h"

@implementation THiPhoneControl

-(id) init{
    self = [super init];
    if(self){
        
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    self.enabled = [decoder decodeBoolForKey:@"enabled"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.enabled forKey:@"enabled"];
}

-(id)copyWithZone:(NSZone *)zone {
    THiPhoneControl * copy = [super copyWithZone:zone];
    copy.enabled = self.enabled;
    
    return copy;
}

#pragma mark - Methods

-(void) setEnabled:(BOOL)enabled{
    UIControl * control = (UIControl*) self.view;
    
    control.enabled = enabled;
}

-(BOOL) enabled{
    UIControl * control = (UIControl*) self.view;
    return control.enabled;
}

-(void) willStartSimulating{
    self.enabled = YES;
    [super willStartSimulating];
}

#pragma mark - Dealloc

-(void) prepareToDie{
    [super prepareToDie];
}

-(NSString*) description{
    return @"iphone control";
}

@end
