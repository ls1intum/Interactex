/*
THBoard.m
Interactex Designer

Created by Juan Haladjian on 10/12/2013.

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

#import "THBoard.h"
#import "THPin.h"
#import "THElementPin.h"
#import "THHardwareComponent.h"

@implementation THBoard

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.pins = [decoder decodeObjectForKey:@"pins"];
        self.i2cComponents = [decoder decodeObjectForKey:@"i2cComponents"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.pins forKey:@"pins"];
    [coder encodeObject:self.i2cComponents forKey:@"i2cComponents"];
}

-(id)copyWithZone:(NSZone *)zone {
    THBoard * copy = [super copyWithZone:zone];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.pins.count];
    for (THPin * pin in self.pins) {
        THPin * copy = [pin copy];
        [array addObject:copy];
    }
    
    copy.pins = array;
    
    for (id<THI2CProtocol> i2cComponent in self.i2cComponents) {
        [copy addI2CComponent:i2cComponent];
    }
    
    return copy;
}

#pragma mark - SCL SDA

-(THBoardPin*) sclPin{
    NSLog(@"Warning, THBoard subclasses should implement method sclPin");
    return nil;
}

-(THBoardPin*) sdaPin{
    NSLog(@"Warning, THBoard subclasses should implement method sdaPin");
    return  nil;
}

#pragma mark - Pins

-(void) attachPin:(THElementPin*) object atPin:(NSInteger) pinNumber{
    THBoardPin * pin = [self.pins objectAtIndex:pinNumber];
    [pin attachPin:object];
    
    if([object.hardware conformsToProtocol:@protocol(THI2CProtocol)] && (pin.supportsSCL || pin.supportsSDA)){
        if((pin.supportsSCL && [self.sdaPin isClotheObjectAttached:object.hardware]) ||
           (pin.supportsSDA && [self.sclPin isClotheObjectAttached:object.hardware])) {
            
            THElementPin<THI2CProtocol> * i2cObject = (THElementPin<THI2CProtocol>*)object.hardware;
            [self addI2CComponent:i2cObject];
        }
    }
}

-(NSInteger) pinIdxForPin:(NSInteger) pinNumber ofType:(THPinType) type{
    return -1;
}

-(THBoardPin*) digitalPinWithNumber:(NSInteger) number{
    return nil;
}
-(THBoardPin*) analogPinWithNumber:(NSInteger) number{
    return nil;
}



#pragma mark - I2C Components

-(void) addI2CComponent:(id<THI2CProtocol>) component{
    [self.i2cComponents addObject:component];
}

-(void) removeI2CComponent:(id<THI2CProtocol>) component{
    [self.i2cComponents removeObject:component];
}

-(id<THI2CProtocol>) I2CComponentWithAddress:(NSInteger) address{
    
    for (id<THI2CProtocol> component in self.i2cComponents) {
        if(component.i2cComponent.address == address){
            return component;
        }
    }
    return nil;
}

@end
