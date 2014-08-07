/*
IFI2CComponent.m
iFirmata

Created by Juan Haladjian on 31/07/2013.

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

#import "IFI2CComponent.h"
#import "IFI2CRegister.h"

@implementation IFI2CComponent

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.address forKey:@"address"];
    [aCoder encodeObject:self.registers forKey:@"registers"];
    [aCoder encodeObject:self.continousReadingRegister forKey:@"mainRegister"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeIntegerForKey:@"address"];
        self.registers = [aDecoder decodeObjectForKey:@"registers"];
        self.continousReadingRegister = [aDecoder decodeObjectForKey:@"mainRegister"];
    }
    return self;
}

#pragma mark - Methods

-(id) init{
    self = [super init];
    if(self){
        self.registers = [NSMutableArray array];
    }
    return self;
}

-(void) addRegister:(IFI2CRegister*) reg{
    
    [self.registers addObject:reg];
    if(self.continousReadingRegister == nil){
        self.continousReadingRegister = reg;
    }
}

-(void) removeRegister:(IFI2CRegister *)reg{
   [self.registers removeObject:reg];
}

-(IFI2CRegister*) registerWithNumber:(NSInteger) number{
    for (IFI2CRegister * reg in self.registers) {
        if(reg.number == number){
            return reg;
        }
    }
    return nil;
}

@end
