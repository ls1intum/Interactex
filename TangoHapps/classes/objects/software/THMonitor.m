/*
THMonitor.m
Interactex Designer

Created by Juan Haladjian on 04/11/2013.

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

#import "THMonitor.h"
#import "THMonitorLine.h"
#import "THMonitorLine.h"
#import "THGraphView.h"

@implementation THMonitor

float const kMonitorUpdateFrequency = 1/30.0f; //monitor updated every 0.5 seconds
float const kMonitorNewValueX = 75.0f;
float const kMonitorMargin = 5;

-(void) loadMonitor{
    
    CGRect frame = CGRectMake(0, 0, self.width, self.height);
    NSLog(@"%f",frame.size.width);
    
    THGraphView * view = [[THGraphView alloc] initWithFrame:frame maxAxisY:self.maxValue minAxisY:self.minValue];
    //view.speed = 2.0f;
    //UIView * view = [[UIView alloc] init];
    view.layer.borderWidth = 1.0f;
    view.contentMode = UIViewContentModeScaleAspectFit;

    self.view = view;
    
    [self addLines];
    [self addMethods];
}

-(void) addLines{
    
    self.lines = [NSMutableArray array];
    
    CGColorRef blue = [[UIColor blueColor] CGColor];
    THMonitorLine * line = [[THMonitorLine alloc] initWithColor:blue];
    
    CGColorRef red = [[UIColor redColor] CGColor];
    THMonitorLine * line2 = [[THMonitorLine alloc] initWithColor:red];
    
    line.view = self.view;
    line2.view = self.view;
    
    [self.lines addObject:line];
    [self.lines addObject:line2];
}

-(void) addMethods{
    
    TFMethod * method1 =[TFMethod methodWithName:@"addValue1"];
    method1.firstParamType = kDataTypeFloat;
    method1.numParams = 1;
    
    TFMethod * method2 =[TFMethod methodWithName:@"addValue2"];
    method2.firstParamType = kDataTypeFloat;
    method2.numParams = 1;
    
    self.methods = [NSMutableArray arrayWithObjects:method1,method2,nil];
}

-(id) init{
    
    self = [super init];
    
    if(self){
        
        self.width = 200;
        self.height = 200;
        
        self.maxValue = 255;
        self.minValue = -255;
        
        [self loadMonitor];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if(self){
        
        self.maxValue = [decoder decodeIntegerForKey:@"maxValue"];
        self.minValue = [decoder decodeIntegerForKey:@"minValue"];
        
        [self loadMonitor];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.maxValue forKey:@"maxValue"];
    [coder encodeInteger:self.minValue forKey:@"minValue"];
}


-(id)copyWithZone:(NSZone *)zone {
    THMonitor * copy = [super copyWithZone:zone];
    
    copy.maxValue = self.maxValue;
    copy.minValue = self.minValue;
    
    return copy;
}

#pragma mark - Methods

-(float) mapValueToGraphRange:(float) value{
    float range = (self.maxValue - self.minValue);
    value = (value / range) * (self.view.frame.size.height - 2 * kMonitorMargin);
    
    return self.view.frame.size.height/2 + value;
}
/*
-(CGPoint) transformedPointForValue:(float) value{
    float range = (self.maxValue - self.minValue);
    value = (value / range) * (self.view.frame.size.height - 2 * kMonitorMargin);
    
    //NSLog(@"value %d",(int)value);
    
    return CGPointMake(self.view.frame.size.width - kMonitorMargin, self.view.frame.size.height/2 - value);
    //return CGPointMake(100, self.view.frame.size.height/2 - value);
}*/

-(void) addValue1:(float) value{
    //NSLog(@"adding value: %f",value);
    /*
    THMonitorLine * line = [self.lines objectAtIndex:0];
    [line addPoint: [self transformedPointForValue:value]];*/
    
    value = [self mapValueToGraphRange:value];
    
    THGraphView * view = (THGraphView*)self.view;
    [view addX:value];
    
}

-(void) addValue2:(float) value{
    /*
    THMonitorLine * line = [self.lines objectAtIndex:1];
    [line addPoint: [self transformedPointForValue:value]];*/
}

-(void) update{
    /*
    for (THMonitorLine * line in self.lines) {
        [line update:kMonitorUpdateFrequency];
    }*/
    
    THGraphView * view = (THGraphView*)self.view;
    [view displaceRight];
}

-(void) start{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:kMonitorUpdateFrequency target:self selector:@selector(update) userInfo:nil repeats:YES];
    _running = YES;
}

-(void) stop{
    [currentTimer invalidate];
    currentTimer = nil;
    _running = NO;
}

-(NSString*) description{
    return @"monitor";
}

-(void) willStartSimulating{
    
    [self start];
    
    [super willStartSimulating];
}

-(void) stopSimulating{
    [self stop];
    
    for (THMonitorLine * line in self.lines) {
        [line removeAllPoints];
    }
    
    [super stopSimulating];
}

-(void) prepareToDie{
    
    [self stop];
    
    [super prepareToDie];
}

@end
