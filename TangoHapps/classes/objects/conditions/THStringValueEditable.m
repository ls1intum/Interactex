/*
THStringValueEditable.m
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THStringValueEditable.h"
#import "THStringValue.h"
#import "THStringValueProperties.h"

@implementation THStringValueEditable

@dynamic value;

CGSize const kStringValueLabelSize = {100,30};

-(void) loadValue{
    self.sprite = [CCSprite spriteWithFile:@"value.png"];
    [self addChild:self.sprite];
    
    [self reloadLabel];
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THStringValue alloc] init];
        
        [self loadValue];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadValue];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THStringValueEditable * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THStringValueProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) reloadLabel{
    [_label removeFromParentAndCleanup:YES];

    NSString * text;
    if(self.value == nil){
        text = @"<empty>";
    } else {
        text = [NSString stringWithFormat:@"%@",self.value];
    }
    
    _label = [CCLabelTTF labelWithString:text dimensions:kStringValueLabelSize hAlignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:14];
    
    //_label = [CCLabelTTF labelWithString:text fontName:kSimulatorDefaultFont fontSize:14 dimensions:kStringValueLabelSize hAlignment:NSTextAlignmentCenter];
    
    _label.position = ccp(25,25);
    [self addChild:_label];
    
    _displayedValue = self.value;
    
}

-(void) update{
    if(![self.value isEqualToString: _displayedValue]){
        [self reloadLabel];
    }
}

-(NSString*) value{
    THStringValue * value = (THStringValue*) self.simulableObject;
    return value.value;
}

-(void) setValue:(NSString*) val{
    THStringValue * value = (THStringValue*) self.simulableObject;
    value.value = [val copy];
    [self reloadLabel];
}

-(NSString*) description{
    return @"String";
}

@end
