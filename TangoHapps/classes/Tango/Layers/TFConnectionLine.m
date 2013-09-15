/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
