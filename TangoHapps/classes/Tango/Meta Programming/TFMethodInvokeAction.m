/*
TFMethodInvokeAction.m
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

#import "TFMethodInvokeAction.h"
#import "TFMethod.h"
#import "TFPropertyInvocation.h"
#import "TFProperty.h"

@implementation TFMethodInvokeAction

+(id) actionWithAction:(TFMethodInvokeAction*) action{
    return [action copy];
}

+(id) actionWithTarget:(id) target method:(TFMethod*) method{
    return [[TFMethodInvokeAction alloc] initWithTarget:target method:method];
}

-(id) initWithTarget:(id) target method:(TFMethod*) method{
    self = [super init];
    if(self){
        self.target = target;
        self.method = method;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    self.method = [decoder decodeObjectForKey:@"method"];
    self.firstParam = [decoder decodeObjectForKey:@"firstParam"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.method forKey:@"method"];
    [coder encodeObject:self.firstParam forKey:@"firstParam"];
}

-(id)copyWithZone:(NSZone *)zone {
    TFMethodInvokeAction * copy = [super copyWithZone:zone];
    
    copy.method = self.method;
    copy.firstParam = [self.firstParam copy];
    
    return copy;
}

#pragma mark - Methods

-(BOOL) isEqualToAction:(TFMethodInvokeAction*)action {
    if(self.target == action.target && [self.method isEqualToMethod:action.method]) return YES;
    return NO;
}

-(void) startAction {
    
    if(self.method.numParams > 0 && !self.firstParam){
        return;
    }
    
    SEL selector = NSSelectorFromString(self.method.signature);
    
    NSMethodSignature *signature = [self.target methodSignatureForSelector:selector];
    
    NSAssert(signature != nil, @"signature not found for method %@ on target %@",self.method,self.target);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.target];
    [invocation setSelector:selector];
    
    if(signature.numberOfArguments > 2){
        
        id result = [self.firstParam invoke];
                
        if(self.method.firstParamType == kDataTypeBoolean){
            
            NSNumber * number = result;
            BOOL b = number.boolValue;
            [invocation setArgument:&b atIndex:2];
            
        } else if(self.method.firstParamType == kDataTypeInteger){
            
            NSNumber * number = result;
            NSInteger i = number.integerValue;
            if(self.method.firstParamType == kDataTypeInteger){
                [invocation setArgument:&i atIndex:2];
            } else if(self.method.firstParamType == kDataTypeFloat){
                float f = (float) i;
                [invocation setArgument:&f atIndex:2];
            }
            
        } else if(self.method.firstParamType == kDataTypeFloat){
            
            NSNumber * number = result;
            float f = number.floatValue;
            if(self.method.firstParamType == kDataTypeInteger){
                NSInteger intValue = (NSInteger) f;
                [invocation setArgument:&intValue atIndex:2];
            } else if(self.method.firstParamType == kDataTypeFloat){
                [invocation setArgument:&f atIndex:2];
            }
            
        }
        //nazmus added 24 sep 14 - to fix the connection bug number and string in simulator mode
        else if(self.method.firstParamType == kDataTypeString){
            
            NSNumber * number = result;
            NSString *b = number.stringValue;
            [invocation setArgument:&b atIndex:2];
            
        }
        ////
        else {
            
            [invocation setArgument:&result atIndex:2];
            
        }
    }
    [invocation invoke];
}

-(void) finishAction{
    
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%@ on %@",self.method, self.target];
}

@end
