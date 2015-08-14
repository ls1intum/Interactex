/*
THiPhoneButton.m
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

#import "THiPhoneButton.h"

@implementation THiPhoneButton

@synthesize text = _text;

-(id) init{
    self = [super init];
    if(self){
        
        self.width = kDefaultButtonSize.width;
        self.height = kDefaultButtonSize.height;
        self.position = CGPointZero;
        self.backgroundColor = [UIColor clearColor];
        
        [self loadMethods];
        
        self.text = @"Button";
    }
    return self;
}

-(void) loadMethods{
    
    TFEvent * event1 = [TFEvent eventNamed:kEventButtonDown];
    TFEvent * event2 = [TFEvent eventNamed:kEventButtonUp];
    self.events = [NSMutableArray arrayWithObjects:event1, event2, nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        self.text = [decoder decodeObjectForKey:@"text"];
        
        [self loadMethods];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.text forKey:@"text"];
}

-(id)copyWithZone:(NSZone *)zone {
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

-(void) updateButtonText{
    
    UIButton * button = (UIButton*) self.view;
    [button setTitle:_text forState:UIControlStateNormal];
    [button setTitle:_text forState:UIControlStateDisabled];
}

-(void) setText:(NSString *)text{
    
    _text = [text copy];
    if(self.view != nil){
        [self updateButtonText];
    }
}

-(void) loadView{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.bounds = CGRectMake(0, 0, self.width, self.height);
    button.layer.cornerRadius = 5;
    self.view = button;
    self.enabled = isSimulating;
    button.titleLabel.font = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize];
    if(!isSimulating){
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor grayColor].CGColor;
    }
    
    [button addTarget:self action:@selector(handleStartedPressing) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(handleStoppedPressing) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateButtonText];
}

-(void) willStartSimulating{
    isSimulating = YES;
    [super willStartSimulating];
}

-(NSString*) description{
    return @"ibutton";
}

@end
