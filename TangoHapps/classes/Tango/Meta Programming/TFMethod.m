/*
TFMethod.m
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

#import "TFMethod.h"

@implementation TFMethod


#pragma mark - Initialization

+(id) methodWithName:(NSString*) name {
    return [[TFMethod alloc] initWithName:name];
}

-(id) initWithName:(NSString*) name {
    self = [super init];
    if(self){
        _name = name;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.returnType = [decoder decodeIntegerForKey:@"returnType"];
    self.firstParamType = [decoder decodeIntegerForKey:@"firstParamType"];
    self.returnsData = [decoder decodeBoolForKey:@"returnsData"];
    self.numParams = [decoder decodeIntegerForKey:@"numParams"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.returnType forKey:@"returnType"];
    [coder encodeInteger:self.firstParamType forKey:@"firstParamType"];
    [coder encodeBool:self.returnsData forKey:@"returnsData"];
    [coder encodeInteger:self.numParams forKey:@"numParams"];
}

-(id)copyWithZone:(NSZone *)zone {
    
    TFMethod * copy = [[TFMethod alloc] init];
    copy.name = self.name;
    copy.returnType = self.returnType;
    copy.firstParamType = self.firstParamType;
    copy.returnsData = self.returnsData;
    copy.numParams = self.numParams;
    return copy;
}

#pragma mark - Methods

-(BOOL) isEqualToMethod:(TFMethod*)method {
    if([self.name isEqualToString:method.name] && self.returnType == method.returnType && self.firstParamType == method.firstParamType && self.returnsData == method.returnsData && self.numParams == method.numParams){
        return YES;
    }
    return NO;
}

-(NSString*) signature {
    NSString * signature = [NSString stringWithFormat:@"%@",self.name];
    if(self.numParams == 1){
        signature = [signature stringByAppendingFormat:@":"];
    }
    return signature;
}

-(BOOL) acceptsParemeterOfType:(TFDataType) type {
    if(self.numParams == 1 && [THClientHelper canConvertParam:type toType:self.firstParamType]){
        return YES;
    }
    return NO;
}

-(NSString*) description {
    NSString * returnString = self.returnsData ? [NSString stringWithFormat:@" (%@)",dataTypeStrings[self.returnType]] : @"";
    NSString * firstParamString = self.numParams > 0 ? [NSString stringWithFormat:@" (%@)",dataTypeStrings[self.firstParamType]] : @"";
 
    return [NSString stringWithFormat:@"%@%@%@",returnString,self.name,firstParamString];
}

@end
