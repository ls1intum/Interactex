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


#import "TFSimulator.h"
#import "TFEditableObject.h"

@implementation TFSimulator

-(id) init
{
	if( (self=[super init])) {
        
        _accelerometerObjects = [NSMutableArray array];
	}
	return self;
}

-(void) addObservers
{
    //id c = [NSNotificationCenter defaultCenter];
}

-(void) removeObservers
{
    //id c = [NSNotificationCenter defaultCenter];
}

#pragma mark - Methods
/*
-(void) addEditableObject:(TFEditableObject*) editableObject{
    [self addChild:editableObject z:editableObject.z];
}*/

-(void) populateAccelerometerObjects{
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.allObjects) {
        if(object.isAccelerometerEnabled){
            [_accelerometerObjects addObject:object];
        }
    }
}

#pragma mark - UI

-(void) accelerated:(UIAcceleration*) acceleration{
    for (TFEditableObject * object in _accelerometerObjects) {
        [object handleAccelerated:acceleration];
    }
}


-(void) tapped:(UITapGestureRecognizer *)sender{
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint location = [sender locationInView:sender.view];
        location = [self toLayerCoords:location];
        
        TFProject * project = [TFDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        if(object){
            [object handleTap];
        }
    }
}

-(void) rotate:(UIRotationGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateChanged){
        CGPoint location = [sender locationInView:sender.view];
        location = [self toLayerCoords:location];
        
        TFProject * project = [TFDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        
        if(object){
            float rotation = sender.rotation;
            [object handleRotation:rotation];
        }
        
        sender.rotation = 0;
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches) {
        
        CGPoint location = [touch locationInView:touch.view];
        location = [[CCDirector sharedDirector] convertToGL:location];
        TFProject * project = [TFDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        if(object){
            [object handleTouchBegan];
        }
    }
}

-(void) handleTouchesEnded:(NSSet*) touches{
    for (UITouch * touch in touches) {
        
        CGPoint location = [touch locationInView:touch.view];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        TFProject * project = [TFDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        
        if(object){
            [object handleTouchEnded];
        }
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesEnded:touches];
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesEnded:touches];
}

#pragma mark - Lifecycle

-(void) update:(float) dt{
    TFProject * project = [TFDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.allObjects) {
        [object update];
    }
}

-(void) prepareObjectsForSimulation{
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    [project willStartSimulation];
}

-(void) notifyObjectsSimulationStarted{
    
    TFProject * project = [TFDirector sharedDirector].currentProject;
    [project didStartSimulation];
}

-(void) willDisappear{
    [self unscheduleUpdate];
    
    [_accelerometerObjects removeAllObjects];
    [super willDisappear];   
}

-(void) willAppear{
    [super willAppear];
    [self prepareObjectsForSimulation];
    [self populateAccelerometerObjects];
    [self scheduleUpdate];
    [self notifyObjectsSimulationStarted];

}

-(NSString*) description{
    return @"TFSimulator";
}

-(void) dealloc{
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
