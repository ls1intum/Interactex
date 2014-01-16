/*
TFConnectionLine.m
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

#import "TFConnectionLine.h"

@implementation TFConnectionLine

@synthesize p1 = _p1;
@synthesize p2 = _p2;

+(id)connectionLine
{
    return [[TFConnectionLine alloc] init];
}

-(id)initWithObj1:(TFEditableObject*) obj1 obj2:(TFEditableObject*) obj2 {
    self = [super init];
    if (self) {
        self.obj1 = obj1;
        self.obj2 = obj2;
        self.color = kConnectionLineDefaultColor;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.color = kConnectionLineDefaultColor;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.obj1 = [decoder decodeObjectForKey:@"obj1"];
        self.obj2 = [decoder decodeObjectForKey:@"obj2"];
        self.p2 = [decoder decodeCGPointForKey:@"p2"];
        self.state = [decoder decodeIntForKey:@"state"];
        self.type = [decoder decodeIntForKey:@"type"];
        self.shouldAnimate = [decoder decodeBoolForKey:@"shouldAnimate"];
        NSInteger red = [decoder decodeIntegerForKey:@"colorR"];
        NSInteger green = [decoder decodeIntegerForKey:@"colorG"];
        NSInteger blue = [decoder decodeIntegerForKey:@"colorB"];
        self.color = ccc3(red, green, blue);
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.obj1 forKey:@"obj1"];
    [coder encodeObject:self.obj2 forKey:@"obj2"];
    [coder encodeCGPoint:self.p2 forKey:@"p2"];
    [coder encodeInt:self.state forKey:@"state"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeBool:self.shouldAnimate forKey:@"shouldAnimate"];
    [coder encodeInt:self.color.r forKey:@"colorR"];
    [coder encodeInt:self.color.g forKey:@"colorG"];
    [coder encodeInt:self.color.b forKey:@"colorB"];
}

#pragma mark - Drawing

-(void) startDrawingSelectedLines{
    
    ccDrawColor4F(1.0, 0.5, 0.5, 1.0);
    glLineWidth(kLineWidthSelected);
}

-(void) startDrawingNormalLines{
    
    ccDrawColor4F(self.color.r, self.color.g, self.color.b, 255);
    glLineWidth(kLineWidthNormal);
}

-(BOOL) calculateShowing{
    if(self.state == kConnectionStateShinning){
        int interval = (int) (timeSinceShinning * 6);
        
        if(interval % 2 == 0){
            return NO;
        }
    }
    return YES;
}

-(void) draw90DegreesLineBetween:(CGPoint) p1 and:(CGPoint) p2{
    //float middleX = (p1.x + p2.x) / 2.0f;
    CGPoint intermediatePoint = ccp(p1.x,p2.y);
    ccDrawLine(p1, intermediatePoint);
    ccDrawLine(intermediatePoint, p2);
}

-(void) draw{
    if(self.selected){
        [self startDrawingSelectedLines];
    } else {
        [self startDrawingNormalLines];
    }
    
    BOOL showing = [self calculateShowing];
    if(showing){
        
        CGPoint p1 = self.p1;
        CGPoint p2 = self.p2;
        
        if(self.type == kConnectionTypeStraight){
            ccDrawLine(p1, p2);
        } else {
            [self draw90DegreesLineBetween:p1 and:p2];
        }
        
        ccDrawCircle(p1, 3, 0, 5, NO);
        ccDrawCircle(p2, 3, 0, 5, NO);
    }
}

#pragma mark - Methods


-(void) updateTime:(NSTimer*) timer{
    
    timeSinceShinning += timer.timeInterval;
    
    if(timeSinceShinning >= kLineAcceptedShinningTime){
        [timer invalidate];
        self.state = kConnectionStateNormal;
    }
}

-(void) startShining{
    
    self.state = kConnectionStateShinning;
    timeSinceShinning = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

-(CGPoint)p1{
    if(self.obj1 == nil)
        return _p1;
    return self.obj1.center;
}

-(CGPoint)p2{
    if(self.obj2 == nil)
        return _p2;
    return self.obj2.center;
}

-(void) setP1:(CGPoint) pos{
    _p1 = pos;
}

-(void) setP2:(CGPoint) pos{
    _p2 = pos;
}

@end
