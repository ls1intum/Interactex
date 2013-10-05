/*
THPotentiometerEditableObject.m
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

#import "THPotentiometerEditableObject.h"
#import "THPotentiometer.h"
#import "THPotentiometerProperties.h"

@implementation THPotentiometerEditableObject

@dynamic value;
@dynamic minValueNotify;
@dynamic maxValueNotify;
@dynamic notifyBehavior;

-(void) loadPotentiometer{
    self.sprite = [CCSprite spriteWithFile:@"potentiometer.png"];
    [self addChild:self.sprite];
    
    CGSize size = CGSizeMake(75, 20);
    
    _valueLabel = [CCLabelTTF labelWithString:@"" fontName:kSimulatorDefaultFont fontSize:15 dimensions:size hAlignment:kCCVerticalTextAlignmentCenter];
    /*
        _valueLabel = [CCLabelTTF labelWithString:@"" dimensions:size hAlignment:NSTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:11];*/
    
    _valueLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2-50);
    _valueLabel.visible = NO;
    [self addChild:_valueLabel z:1];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THPotentiometer alloc] init];
        
        self.type = kHardwareTypePotentiometer;
        
        [self loadPotentiometer];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadPotentiometer];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THPotentiometerEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THPotentiometerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Pins

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) analogPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) plusPin{
    return [self.pins objectAtIndex:2];
}

#pragma mark - Methods

-(void) handleTouchBegan{
    self.isDown = YES;
}

-(void) handleTouchEnded{
    self.isDown = NO;
}

-(void) update{
    
    if(self.isDown){
        _touchDownIntensity += 2.0f;
    } else {
        _touchDownIntensity -= 1.0f;
    }
    _touchDownIntensity = [THClientHelper Constrain:_touchDownIntensity min:0 max:kMaxPotentiometerValue];
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.value = _touchDownIntensity;
    _valueLabel.string = [NSString stringWithFormat:@"%d",potentiometer.value];
    //potentiometer.opacity = _touchDownIntensity;
}

-(NSInteger) value{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.value;
}

-(NSInteger) minValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.minValueNotify;
}

-(void) setMinValueNotify:(NSInteger)minValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.minValueNotify = minValueNotify;
}

-(NSInteger) maxValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.maxValueNotify;
}

-(void) setMaxValueNotify:(NSInteger)maxValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.maxValueNotify = maxValueNotify;
}

-(THSensorNotifyBehavior) notifyBehavior{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.notifyBehavior;
}

-(void) setNotifyBehavior:(THSensorNotifyBehavior)notifyBehavior{
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.notifyBehavior = notifyBehavior;
}

-(void) handleRotation:(float) degree{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    _value += degree*10;

    _value = [THClientHelper Constrain:_value min:0 max:kMaxPotentiometerValue];
    potentiometer.value = (NSInteger) _value;
}

-(void) willStartEdition{
    _valueLabel.visible = NO;
}

-(void) willStartSimulation{
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    _value = potentiometer.value;
    _valueLabel.visible = YES;
    
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Potentiometer";
}

@end
