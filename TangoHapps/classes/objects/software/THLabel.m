/*
THLabel.m
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

#import "THLabel.h"
#import "THPaddingLabel.h"

@implementation THLabel

@synthesize numLines = _numLines;
@synthesize text = _text;

const CGSize kLabelPadding = {15,10};

-(id) init{
    self = [super init];
    if(self){
        
        self.width = kDefaultLabelSize.width;
        self.height = kDefaultLabelSize.height;
        
        [self loadMethods];
        
        self.text = @"Label";
        self.numLines = 0;
    }
    return self;
}

-(void) loadMethods{
    
    TFMethod * method1 =[TFMethod methodWithName:kMethodSetText];
    method1.firstParamType = kDataTypeAny;
    method1.numParams = 1;
    
    TFMethod * method2 =[TFMethod methodWithName:@"appendText"];
    method2.firstParamType = kDataTypeAny;
    method2.numParams = 1;
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if(self){
        
        self.text = [decoder decodeObjectForKey:@"text"];
        self.numLines = [decoder decodeIntegerForKey:@"numLines"];
        
        [self loadMethods];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeInteger:self.numLines forKey:@"numLines"];
}

-(id)copyWithZone:(NSZone *)zone {
    THLabel * copy = [super copyWithZone:zone];
    
    copy.text = self.text;
    copy.numLines = self.numLines;
    
    return copy;
}

#pragma mark - Methods

-(void) updateLabelNumLines{
    UILabel * label = (UILabel*) self.view;
    label.numberOfLines = _numLines;
}

-(void) setNumLines:(NSInteger)numLines{
    _numLines = numLines;
    if(labelLoaded){
        [self updateLabelNumLines];
    }
}

-(NSInteger) numLines{
    UILabel * label = (UILabel*) self.view;
    return label.numberOfLines;
}

-(NSString*) convertToString:(id) text{
    NSString * string = @"";
    if([text isKindOfClass:[NSString class]]){
        string = (NSString*) text;
    } else if([text isKindOfClass:[NSNumber class]]){
        NSNumber * number = text;
        string = [number stringValue];
    } else if([text isKindOfClass:[NSObject class]]){
        string = ((NSObject*)text).description;
    }
    return string;
}

-(void) appendText:(id) text{
    
    UILabel * label = (UILabel*) self.view;
    
    NSString * string = [self convertToString:text];
    label.text = [label.text stringByAppendingString:string];
}

-(void) updateLabelText{
    UILabel * label = (UILabel*) self.view;
    NSString * string = [self convertToString:_text];
    label.text = string;
}

-(void) setText:(id)text{
    
    _text = [text copy];
    
    if(labelLoaded){
        [self updateLabelText];
    }
}

-(void) loadView{
    
    THPaddingLabel * label = [[THPaddingLabel alloc] init];
    label.bounds = CGRectMake(0, 0, self.width, self.height);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.view = label;
    
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    labelLoaded = YES;
    
    [self updateLabelNumLines];
    [self updateLabelText];
}

#pragma mark - Other

-(NSString*) description{
    return @"label";
}

@end
