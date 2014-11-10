/*
IFPin.m
iFirmata

Created by Juan Haladjian on 27/06/2013.

iFirmata is an App to control an Arduino board over Bluetooth 4.0. iFirmata uses the Firmata protocol: www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "IFPin.h"

@implementation IFPin

+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    return [[IFPin alloc] initWithNumber:number type:type mode:mode];
}

-(id) initWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    self = [super init];
    if(self){
        self.number = number;
        self.type = type;
        self.mode = mode;
        if(_mode == IFPinModeInput){
            _value = 1;
        }
        if(self.type == IFPinTypeAnalog){
            self.analogChannel = 127;
        }
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        self.number = [decoder decodeIntForKey:@"number"];
        self.type = [decoder decodeIntForKey:@"type"];
        self.mode = [decoder decodeIntForKey:@"mode"];
        
        self.analogChannel = [decoder decodeIntForKey:@"analogChannel"];
        self.supportedModes = [decoder decodeIntForKey:@"supportedModes"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInteger:self.number forKey:@"number"];
    [coder encodeInteger:self.type forKey:@"type"];
    [coder encodeInteger:self.mode forKey:@"mode"];
    [coder encodeInteger:self.analogChannel forKey:@"analogChannel"];
    [coder encodeInteger:self.supportedModes forKey:@"supportedModes"];
}

-(id)copyWithZone:(NSZone *)zone {
    IFPin * copy = [super init];
    if(copy){
        copy.number = self.number;
        copy.type = self.type;
        copy.mode = self.mode;
        copy.analogChannel = self.analogChannel;
        copy.supportedModes = self.supportedModes;
    }
    return copy;
}

#pragma mark - Methods

-(BOOL) supportsPwm{
    return (self.type == IFPinTypeDigital && (self.number == 3 || self.number == 5 || self.number == 6 || self.number == 9 || self.number == 10 || self.number == 11));
}

-(void) setMode:(IFPinMode)mode{
    if(mode != self.mode){
        _mode = mode;
    }
}

-(void) setValue:(NSInteger)value{
    if(value != _value){
        _value = value;
    }
    
}

@end
