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

#import "TFLayer.h"
#import "TFEditableObject.h"
#import "THProjectViewController.h"

@implementation TFLayer

@synthesize lastAcceleration;

+(CCScene*) scene{
    CCScene * scene = [CCScene node];
    [scene addChild: [self node]];
    
    return scene;
}

-(id) init{
    self = [super init];
    if(self){
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        //_zoomableLayer.contentSize = self.contentSize;

        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/30.0f];
    }
    return self;
}

#pragma mark - Gesture Recognition

-(void)addGestureRecognizers
{
    UIView * glView = [CCDirector sharedDirector].view;
    
    // Pinch
    UIPinchGestureRecognizer *pinchRecognizer =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    pinchRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:pinchRecognizer];
    
    // Rotate
    UIRotationGestureRecognizer *rotationRecognizer =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    rotationRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:rotationRecognizer];
    
    // Pan
    self.panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.panRecognizer setDelegate:self];
	[self.panRecognizer setMinimumNumberOfTouches:1];
	[self.panRecognizer setMaximumNumberOfTouches:3];
    self.panRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:self.panRecognizer];
    
    // Tap
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapRecognizer setDelegate:self];
	[tapRecognizer setNumberOfTapsRequired:1];
    tapRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:tapRecognizer];
    
    // Double Tap
    UITapGestureRecognizer *doubleTapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTapRecognizer setDelegate:self];
	[doubleTapRecognizer setNumberOfTapsRequired:2];
    doubleTapRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:doubleTapRecognizer];
    
    // Long Press
    UILongPressGestureRecognizer *longpressRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
    [longpressRecognizer setDelegate:self];
    longpressRecognizer.cancelsTouchesInView = NO;
	[glView addGestureRecognizer:longpressRecognizer];
}

-(void) removeGestureRecognizers{
    UIView * glView = [CCDirector sharedDirector].view;
    glView.gestureRecognizers = nil;
}

//-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //return ![THDirector sharedDirector].projectController.movingTabBar;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
}

-(void) scale:(UIPinchGestureRecognizer*)sender{}
-(void) rotate:(UIRotationGestureRecognizer*) sender{}
-(void) move:(UIPanGestureRecognizer*)sender{}
-(void) tapped:(UITapGestureRecognizer*)sender{}
-(void) doubleTapped:(UITapGestureRecognizer*)sender{}
-(void) pressedLong:(UILongPressGestureRecognizer*)sender{}
-(void) accelerated:(UIAcceleration*) acceleration{}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [self accelerated:acceleration];
}

#pragma mark - Methods

-(void) addEditableObject:(TFEditableObject*) editableObject{
    
    [self addChild:editableObject z:editableObject.z];
}

-(void) removeEditableObject:(TFEditableObject*) editableObject{
    [editableObject removeFromParentAndCleanup:YES];
}

#pragma mark - Lifecycle

-(void) willDisappear{
    self.isAccelerometerEnabled = NO;
    [self removeGestureRecognizers];
}

-(void) willAppear{
    
    self.isAccelerometerEnabled = YES;
    [self addGestureRecognizers];
}

#pragma mark - Coordinates

- (CGPoint)toLayerCoords:(CGPoint)touchLocation {
	CGPoint newPos = [[CCDirector sharedDirector] convertToGL: touchLocation];
	newPos = [self convertToNodeSpace:newPos];
	return newPos;
}

-(void) prepareToDie{
    [self removeGestureRecognizers];
}

-(void) dealloc{
}

@end
