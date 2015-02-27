/*
THView.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

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

-(CGColorRef) defaultBorderColor{
     return [UIColor darkGrayColor].CGColor;
}

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
