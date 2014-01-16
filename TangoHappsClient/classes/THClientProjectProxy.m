/*
THClientProjectProxy.m
Interactex Client

Created by Juan Haladjian on 12/11/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THClientProjectProxy.h"

@implementation THClientProjectProxy

#pragma mark - Construction

+(id) proxyWithName:(NSString*) name{
    return [[THClientProjectProxy alloc] initWithName:name];
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        /*
        NSString * imageFile = [self.name stringByAppendingString:@".png"];
        NSString * imagePath = [TFFileUtils dataFile:imageFile
                                             inDirectory:kProjectImagesDirectory];
        if([TFFileUtils dataFile:imageFile existsInDirectory:kProjectImagesDirectory])
            self.image = [UIImage imageWithContentsOfFile:imagePath];*/
        
        self.date = [NSDate date];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.date forKey:@"date"];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone{
    THClientProjectProxy * proxy = [[THClientProjectProxy alloc] initWithName:self.name];
    proxy.image = self.image;
    return proxy;
}

@end
