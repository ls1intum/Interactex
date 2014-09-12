/*
THiPhoneEditableObject.m
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

#import "THiPhoneEditableObject.h"
#import "THiPhoneProperties.h"
#import "THView.h"
#import "THViewEditableObject.h"
#import "THiPhone.h"
#import "THViewEditableObject.h"
#import "THView.h"
#import "THEditor.h"
#import "THInvocationConnectionLine.h"

@implementation THiPhoneEditableObject
@dynamic type;

-(void) reloadiPhoneSprite{
    self.z = kiPhoneZ;
    
    if(self.sprite != nil){
        [self.sprite removeFromParentAndCleanup:YES];
    }
    NSString * fileName = (self.type == kiPhoneType4S) ? @"iphone4.png" : @"iphone5.png";
    self.sprite = [CCSprite spriteWithFile:fileName];
    [self addChild:self.sprite z:kiPhoneZ];
}

-(void) loadSprite{
    
    [self reloadiPhoneSprite];
    
    self.z = kiPhoneZ;
    self.canBeScaled = NO;
    self.canBeDuplicated = NO;
    self.canBeAddedToGesture = NO;
}

+(id) iPhoneWithDefaultView{
    
    THiPhoneEditableObject * iPhone = [[THiPhoneEditableObject alloc] init];
    THViewEditableObject * view = [THViewEditableObject newView];
    view.opacity = kUiViewOpacityEditor;
    view.canBeResized = NO;
    iPhone.currentView = view;

    return iPhone;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THiPhone alloc] init];
        [self loadSprite];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        
        _currentView = [decoder decodeObjectForKey:@"currentView"];
        _currentView.canBeDuplicated = NO;
        [self addChild:_currentView];
        
        [self loadSprite];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_currentView forKey:@"currentView"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THiPhone * copy = [super copyWithZone:zone];
    copy.currentView = [_currentView copy];
    copy.position = self.position;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THiPhoneProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    self.currentView.visible = visible;
    [super setVisible:visible];
}

-(void) adaptViewSizeToIphoneType{
    self.currentView.width = kiPhoneFrames[self.type].size.width;
    self.currentView.height = kiPhoneFrames[self.type].size.height;
}

-(void) setType:(THIPhoneType)type{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.type = type;
    [self reloadiPhoneSprite];
    [self adaptViewSizeToIphoneType];
}

-(THIPhoneType) type{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    return iPhone.type;
}

-(void) removeFromSuperview{
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone removeFromSuperview];
}

-(void) addToView:(UIView*) aView{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone addToView:aView];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
    
    [(THiPhone*)self.simulableObject addToView:[CCDirector sharedDirector].view];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(void) setCurrentView:(THViewEditableObject *)currentView{
    
    if(currentView != nil){
        CGRect frame = kiPhoneFrames[self.type];
        currentView.width = frame.size.width;
        currentView.height = frame.size.height;
        
        [self addChild:currentView];
    }
    
    _currentView = currentView;
    _currentView.canBeDuplicated = NO;
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.currentView = (THView*) currentView.simulableObject;
}

-(void) setPosition:(CGPoint)position{
    
    [super setPosition:position];
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.position = [TFHelper ConvertToCocos2dView:self.position];
    
    CGPoint pos = [TFHelper ConvertToCocos2dView:self.position];
    _currentView.position = pos;
}

-(void) displaceBy:(CGPoint)displacement{
    
    [super displaceBy:displacement];
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.position = [TFHelper ConvertToCocos2dView:self.position];
}

-(void) scaleBy:(float)scale{
    
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhone:self];
}

-(void) removeFromWorld{
    //[_currentView removeFromWorld];
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeiPhone];
    
    [super removeFromWorld];
}

-(void) makeEmergencyCall{
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone makeEmergencyCall];
}

-(NSString*) description{
    return @"iPhone";
}

-(void) willStartEdition{
    
    self.currentView.opacity = kUiViewOpacityEditor;
    [self.currentView willStartEdition];
    [super willStartEdition];
}

-(void) willStartSimulation{
    self.currentView.opacity = 1.0f;
    [super willStartSimulation];
}

-(void) prepareToDie{
    
    [_currentView prepareToDie];
    _currentView = nil;
    
    [self removeFromSuperview];
    [super prepareToDie];
}

@end
