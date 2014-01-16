/*
GMPPin.m
iGMP

Created by Juan Haladjian on 27/06/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "GMPPin.h"

@implementation GMPPin

/*
+(id) pinWithNumber:(NSInteger) number type:(IFPinType) type mode:(IFPinMode) mode{
    return [[GMPPin alloc] initWithNumber:number type:type mode:mode];
}*/

-(id) initWithNumber:(NSInteger) number{
    self = [super init];
    if(self){
        self.number = number;
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
        self.supportedModes = [decoder decodeIntForKey:@"supportedModes"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInt:self.number forKey:@"number"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeInt:self.mode forKey:@"mode"];
    [coder encodeInt:self.supportedModes forKey:@"supportedModes"];
}

-(id)copyWithZone:(NSZone *)zone {
    GMPPin * copy = [super init];
    if(copy){
        
        copy.number = self.number;
        copy.type = self.type;
        copy.mode = self.mode;
        copy.supportedModes = self.supportedModes;
    }
    return copy;
}

#pragma mark - Methods

-(BOOL) supportsPwm{
    return NO;
}

@end
