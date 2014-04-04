//
//  THGestures.m
//  TangoHapps
//
//  Created by Timm Beckmann on 03/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGesture.h"
#import "THView.h"

@implementation THGesture

-(void) loadGesture{
    
    TFMethod * method = [TFMethod methodWithName:@"saveGesture"];
    self.methods = [NSMutableArray arrayWithObject:method];
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadGesture];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    [self loadGesture];
    
    self.position = [decoder decodeCGPointForKey:@"position"];
    _currentView = [decoder decodeObjectForKey:@"currentView"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:self.position forKey:@"position"];
    [coder encodeObject:_currentView forKey:@"currentView"];
}

-(id)copyWithZone:(NSZone *)zone {
    THGesture * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    self.currentView.visible = visible;
    [super setVisible:visible];
}

-(void) removeFromSuperview{
    [_currentView removeFromSuperview];
}

-(void) addToView:(UIView*) aView{
    [_currentView addToView:aView];
}

-(void) setCurrentView:(THView *)currentView{
    UIView * superview = _currentView.superview.view;
    [_currentView removeFromSuperview];
    _currentView = currentView;
    if(currentView != nil){
        [currentView addToView:superview];
    }
}

-(void) saveGesture {
    
}

-(NSString*) description{
    return @"gesture";
}

-(void) prepareToDie{
    
    _currentView = nil;
    [super prepareToDie];
}
@end
