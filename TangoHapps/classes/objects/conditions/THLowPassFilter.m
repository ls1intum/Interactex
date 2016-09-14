/*
 THLowPassFilter.m
 Interactex Designer
 
 Created by Juan Haladjian on 009/03/16.
 
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


#import "THLowPassFilter.h"

@implementation THLowPassFilter


-(id) init{
    self = [super init];
    if(self){
        [self loadLowPassFilter];
        
    }
    return self;
}

-(void) loadLowPassFilter{
    
    TFProperty * property = [TFProperty propertyWithName:@"filteredSignal" andType:kDataTypeAny];
    self.properties = [NSMutableArray arrayWithObject:property];
    
    TFMethod * method = [TFMethod methodWithName:@"addSample"];
    method.numParams = 1;
    method.firstParamType = kDataTypeFloat;
    
    TFMethod * method2 = [TFMethod methodWithName:@"addSamples"];
    method2.numParams = 1;
    method2.firstParamType = kDataTypeAny;
    
    self.methods = [NSMutableArray arrayWithObjects:method, method2, nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventFiltered];
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObject:event];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadLowPassFilter];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THLowPassFilter * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods


-(void) filter{
    
    //filter code goes here
    
    [self triggerEventNamed:kEventFiltered];
}

-(void) emptyWindow{
    
    [self.data removeAllObjects];
}

-(void) addSample:(id) sample{
    [self.data addObject:sample];
    if(self.data.count >= kFilterMaxSamples){
        [self filter];
        [self emptyWindow];
    }
}

-(void) addSamples:(id) samples{
    self.data = samples;
    [self filter];
    [self emptyWindow];
}

-(void) didStartSimulating{
    //[self triggerEventNamed:kEventDeviationChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"lowPassFilter";
}


@end
