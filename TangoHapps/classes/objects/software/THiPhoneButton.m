//
//  THiPhoneButton.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneButton.h"

@implementation THiPhoneButton

-(void) loadButton{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.bounds = CGRectMake(0, 0, self.width, self.height);
    self.view = button;

    [button addTarget:self action:@selector(handleStartedPressing) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(handleStoppedPressing) forControlEvents:UIControlEventTouchUpInside];
    
    TFEvent * event1 = [TFEvent eventNamed:@"touchDown"];
    TFEvent * event2 = [TFEvent eventNamed:@"touchUp"];
    self.events = [NSArray arrayWithObjects:event1, event2, nil];
}

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 100;
        self.height = 50;
        self.position = CGPointZero;
        
        [self loadButton];
        
        self.text = @"Button";
        self.enabled = NO;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadButton];
    
    self.text = [decoder decodeObjectForKey:@"text"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.text forKey:@"text"];
}


-(id)copyWithZone:(NSZone *)zone
{
    THiPhoneButton * copy = [super copyWithZone:zone];
    copy.text = self.text;
    
    return copy;
}

#pragma mark - Methods

-(void) handleStartedPressing{
    TFEvent * event = [self.events objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:event.name  object:self];
}

-(void) handleStoppedPressing{
    TFEvent * event = [self.events objectAtIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:event.name  object:self];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
}

-(UIColor*) backgroundColor{
    return nil;
}

-(void) setText:(NSString *)text{
    
    UIButton * button = (UIButton*) self.view;
    [button setTitle:text forState:UIControlStateNormal];
}

-(NSString*) text{
    UIButton * button = (UIButton*) self.view;
    return [button titleForState:UIControlStateNormal];
}

-(NSString*) description{
    return @"ibutton";
}

@end
