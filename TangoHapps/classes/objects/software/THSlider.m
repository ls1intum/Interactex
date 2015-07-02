/*
THSlider.m
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

#import "THSlider.h"

@implementation THSlider

@synthesize min = _min;
@synthesize max = _max;
@synthesize value = _value;

-(id) init{
    self = [super init];
    if(self){
        
        self.width = kDefaultSliderSize.width;
        self.height = kDefaultSliderSize.height;
        self.position = CGPointZero;
        self.backgroundColor = [UIColor clearColor];
        
        //[self loadSliderView];
        [self loadMethods];
        
        self.min = 0;
        self.max = 255;
    }
    return self;
}

-(void) loadSliderView{
    
    UISlider * slider = [[UISlider alloc] init];
    //slider.backgroundColor = [UIColor colorWithRed:0.88 green:0.69 blue:0.48 alpha:1];
    slider.frame = CGRectMake(0, 0, self.width, self.height);
    self.view = slider;
    slider.enabled = NO;
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = NO;
    
    [slider addTarget:self action:@selector(handleValueChanged) forControlEvents:UIControlEventValueChanged];
}


-(void) loadMethods{
    
    TFProperty * valueProperty = [TFProperty propertyWithName:@"value" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObjects:valueProperty,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventValueChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:valueProperty target:self];
    self.events = [NSMutableArray arrayWithObjects:event1, nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    //[self loadSliderView];
    [self loadMethods];
    
    self.value = [decoder decodeFloatForKey:@"value"];
    self.min = [decoder decodeFloatForKey:@"min"];
    self.max = [decoder decodeFloatForKey:@"max"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:self.value forKey:@"value"];
    [coder encodeFloat:self.min forKey:@"min"];
    [coder encodeFloat:self.max forKey:@"max"];
}

-(id)copyWithZone:(NSZone *)zone {
    THSlider * copy = [super copyWithZone:zone];
    
    copy.value = self.value;
    copy.min = self.min;
    copy.max = self.max;
    
    return copy;
}

#pragma mark - Methods

-(float) value{
    return _value;
    
    //return ((UISlider*)self.view).value;
}

-(void) setValue:(float)value{
    _value = value;
    
    if(self.view){
        ((UISlider*)self.view).value = value;
    }
}

-(float) min{
    return _min;
    
    //return ((UISlider*)self.view).minimumValue;
}

-(void) setMin:(float)min{
    _min = min;
    if(self.view != nil){
        [self updateSliderMin];
    }
}

-(float) max{
    return _max;
    //return ((UISlider*)self.view).maximumValue;
}

-(void) setMax:(float)max{
    _max = max;
    if(self.view != nil){
        [self updateSliderMax];
    }
}

-(void) updateSliderMin{
    
    ((UISlider*)self.view).minimumValue = self.min;
}

-(void) updateSliderMax{
    
    ((UISlider*)self.view).maximumValue = self.max;
}

-(void) updateSliderValue{
    
    ((UISlider*)self.view).value = self.value;
}

-(void) updateSliderView{
    [self updateSliderMin];
    [self updateSliderMax];
    [self updateSliderValue];
    ((UISlider*)self.view).enabled = self.enabled;
}

-(void) handleValueChanged{
    _value = ((UISlider*)self.view).value;
    
    [self triggerEventNamed:kEventValueChanged];
}

-(void) loadView{
    [self loadSliderView];
    [self updateSliderView];
}

#pragma mark - Other

-(void) didStartSimulating{
    ((UISlider*) self.view).enabled = YES;
    
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return [NSString stringWithFormat:@"slder: %p",self];
}

@end
