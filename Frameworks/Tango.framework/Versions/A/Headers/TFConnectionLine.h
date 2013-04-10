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


#import <Foundation/Foundation.h>

@class TFEditableObject;

typedef enum
{
    kConnectionStateNormal,
    kConnectionStateDrawing,
    kConnectionStateShinning
} TFConnectionState;

typedef enum
{
    kConnectionTypeStraight,
    kConnectionType90Degrees
} TFConnectionType;

@interface TFConnectionLine : NSObject
{
    float timeSinceShinning;
}

@property(nonatomic) TFEditableObject * obj1;
@property(nonatomic) TFEditableObject * obj2;

@property(nonatomic) CGPoint p1;
@property(nonatomic) CGPoint p2;

@property(nonatomic) TFConnectionState state;
@property(nonatomic) TFConnectionType type;
@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL shouldAnimate;
@property(nonatomic) ccColor3B color;

+(id)connectionLine;
-(id)init;
-(void) draw;
-(void) startShining;

@end