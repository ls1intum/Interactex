//
//  THiPhoneView.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THView.h"

@implementation THView

@synthesize width = _width;
@synthesize height = _height;
@synthesize position = _position;
@synthesize opacity = _opacity;
@synthesize backgroundColor = _backgroundColor;
@dynamic visible;

-(void) loadView{
    
    UIView * view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, self.width, self.height);
    view.alpha = self.opacity;
    self.view = view;
}

-(id) init{
    self = [super init];
    if(self){
        
        _subviews = [NSMutableArray array];
        self.width = 100;
        self.height = 50;
        self.opacity = 1;
        
        [self loadView];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.width = [decoder decodeFloatForKey:@"width"];
        self.height = [decoder decodeFloatForKey:@"height"];
        self.opacity = [decoder decodeFloatForKey:@"opacity"];
        self.position = [decoder decodeCGPointForKey:@"position"];
        self.backgroundColor = [decoder decodeObjectForKey:@"backgroundColor"];
        
        _subviews = [NSMutableArray array];
        
        [self loadView];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:self.width forKey:@"width"];
    [coder encodeFloat:self.height forKey:@"height"];
    [coder encodeFloat:self.opacity forKey:@"opacity"];
    [coder encodeCGPoint:self.position forKey:@"position"];
    [coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
}

-(id)copyWithZone:(NSZone *)zone {
    THView * copy = [super copyWithZone:zone];
    copy.width = self.width;
    copy.height = self.height;
    copy.opacity = self.opacity;
    copy.position = self.position;
    copy.backgroundColor = self.backgroundColor;
    
    for (THView * view in _subviews) {
        [copy addSubview:view];
    }
    
    return copy;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    if(visible != self.visible){
        self.view.hidden = !visible;
        for (THView * view in _subviews) {
            view.visible = visible;
        }
        [super setVisible:visible];
    }
}

-(void) addSubview:(THView*) object {
    
    [_view.superview addSubview:object.view];
    object.superview = self;
    
    [_subviews addObject:object];
}

-(void) removeSubview:(THView*) object {
    [_subviews removeObject:object];
}

-(void) removeFromSuperview{
    [self.view removeFromSuperview];
    
    NSArray * copy = [NSArray arrayWithArray:_subviews];
    for (THView * view in copy) {
        [view removeFromSuperview];
    }
    
    [self.superview removeSubview:self];
    self.superview = nil;
    [_subviews removeAllObjects];
}

-(void) addToView:(UIView*) aView{
    
    [self.view removeFromSuperview];
    
    [aView addSubview:self.view];
    for (THView * view in _subviews) {
        [view addToView:aView];
    }
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    self.view.backgroundColor = backgroundColor;
    _backgroundColor = backgroundColor;
}

-(void) setWidth:(float)width{
    
    CGPoint center = self.view.center;
    CGPoint origin = self.view.frame.origin;
    self.view.frame = CGRectMake(origin.x, origin.y, width, self.view.frame.size.height);
    self.view.center = center;
    _width = width;
}

-(void) setHeight:(float)height{
    
    CGPoint center = self.view.center;
    CGPoint origin = self.view.frame.origin;
    self.view.frame = CGRectMake(origin.x, origin.y, self.view.frame.size.width, height);
    self.view.center = center;
    _height = height;
}

-(void) setPosition:(CGPoint)position{

    self.view.center = position;
    _position = position;
}

-(void) setOpacity:(float)opacity{
 
    self.view.alpha = opacity;
    _opacity = opacity;
}

-(void) setView:(UIView*)view{
    
    view.frame = CGRectMake(self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height);
    _view = view;
    view.backgroundColor = self.backgroundColor;
}

-(NSString*) description{
    return @"view";
}

-(void) prepareToDie{
    [self removeFromSuperview];
    _subviews = nil;
    self.superview = nil;
    
    [super prepareToDie];
}

@end
