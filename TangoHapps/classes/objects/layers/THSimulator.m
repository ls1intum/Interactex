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


#import "THSimulator.h"
#import "TFEditableObject.h"

#import "THiPhoneEditableObject.h"
#import "THiPhone.h"

#import "THPinValue.h"
#import "THBoardPinEditable.h"
#import "THLilypadEditable.h"
#import "THBoardPin.h"

#import "THPinsController.h"
#import "THPinsControllerContainer.h"

@implementation THSimulator

-(id) init {
    
    self = [super init];
    if(self){
        
        _zoomableLayer = [CCLayer node];
        [self addChild:_zoomableLayer z:-1];
        
        _accelerometerObjects = [NSMutableArray array];
	}
	return self;
}


#pragma mark - Methods

-(void) populateAccelerometerObjects{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.allObjects) {
        if(object.isAccelerometerEnabled){
            [_accelerometerObjects addObject:object];
        }
    }
}

#pragma mark - gesture Recognition

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches) {
        
        CGPoint location = [touch locationInView:touch.view];
        location = [[CCDirector sharedDirector] convertToGL:location];
        THProject * project = [THDirector sharedDirector].currentProject;
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
        
        THProject * project = [THDirector sharedDirector].currentProject;
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


-(void) accelerated:(UIAcceleration*) acceleration{
    for (TFEditableObject * object in _accelerometerObjects) {
        [object handleAccelerated:acceleration];
    }
}


-(void) tapped:(UITapGestureRecognizer *)sender{
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint location = [sender locationInView:sender.view];
        location = [self toLayerCoords:location];
        
        THProject * project = [THDirector sharedDirector].currentProject;
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
        
        THProject * project = [THDirector sharedDirector].currentProject;
        TFEditableObject * object = [project objectAtLocation:location];
        
        if(object){
            float rotation = sender.rotation;
            [object handleRotation:rotation];
        }
        
        sender.rotation = 0;
    }
}

#pragma mark - Moving and Zooming layer

-(void) setZoomLevel:(float)zoomLevel{
    self.zoomableLayer.scale = zoomLevel;
}

-(float) zoomLevel{
    return self.zoomableLayer.scale;
}

-(void) setDisplacement:(CGPoint)displacement{
    self.zoomableLayer.position = displacement;
}

-(CGPoint) displacement{
    return self.zoomableLayer.position;
}

-(void) moveLayer:(CGPoint) d{
    self.zoomableLayer.position = ccpAdd(_zoomableLayer.position, d);
    //self.position = ccpAdd(self.position, d);
}

-(void)scale:(UIPinchGestureRecognizer*)sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    float newScale = self.zoomableLayer.scale * sender.scale;
    if(newScale > kLayerMinScale && newScale < kLayerMaxScale)
        self.zoomableLayer.scale = newScale;
    sender.scale = 1.0f;
}

-(void) doubleTapped:(UITapGestureRecognizer*)sender{
    
    CGPoint location = [sender locationInView:sender.view];
    location = [self toLayerCoords:location];
    
    THProject * project = [THDirector sharedDirector].currentProject;
    TFEditableObject * object = [project objectAtLocation:location];
    
    if(!object) {
        _zoomableLayer.scale = 1.0f;
        _zoomableLayer.position = ccp(0,0);
    }
    
    [super doubleTapped:sender];
}

-(void) move:(UIPanGestureRecognizer*)sender{
    
    
    if(sender.numberOfTouches == 1){
        
        CGPoint location = [sender locationInView:sender.view];
        location = [self toLayerCoords:location];
        
        if(sender.state == UIGestureRecognizerStateChanged){
            
            THProject * project = [THDirector sharedDirector].currentProject;
            TFEditableObject * object = [project objectAtLocation:location];
            if(!object){
                
                CGPoint d = [sender translationInView:sender.view];
                d.y = - d.y;
                
                [self moveLayer:d];
                
                [sender setTranslation:ccp(0,0) inView:sender.view];
            }
        }
    }
}


#pragma mark - Adding and Removing objects

-(void) addObjects{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if(project.iPhone != nil){
        [project.iPhone addToLayer:self];
    }
    for (TFEditableObject * object in project.allObjects) {
        [object addToLayer:self];
    }
}

-(void) removeObjects{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    if(project.iPhone != nil){
        [project.iPhone removeFromLayer:self];
    }
    
    [self removeAllChildrenWithCleanup:YES];
}

#pragma mark - PinsController

-(void) addPinsController{
    CGSize const kPinsControllerSize = {330, kPinsControllerMinHeight};
    
    CGRect frame = CGRectMake(690,310,kPinsControllerSize.width,kPinsControllerSize.height);
    _pinsController = [[THPinsController alloc] initWithFrame:frame];
    
    [[CCDirector sharedDirector].view addSubview:_pinsController];
    
    _state = kSimulatorStatePins;
}

-(void) removePinsController{
    if(_pinsController != nil) {
        [_pinsController prepareToDie];
        [_pinsController removeFromSuperview];
        _pinsController = nil;
    }
    _state = kSimulatorStateNormal;
}

-(void) addEditableObject:(TFEditableObject*) editableObject{
    if(editableObject.canBeScaled){
        [self.zoomableLayer addChild:editableObject z:editableObject.z];
    } else{
        [super addEditableObject:editableObject];
    }
}

#pragma mark - Layer Lifecycle


-(void) update:(float) dt{
    THProject * project = [THDirector sharedDirector].currentProject;
    for (TFEditableObject * object in project.allObjects) {
        [object update];
    }
}

-(void) prepareObjectsForSimulation{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project willStartSimulation];
}

-(void) notifyObjectsSimulationStarted{
    
    THProject * project = [THDirector sharedDirector].currentProject;
    [project didStartSimulation];
}

-(void) willDisappear{
    [self unscheduleUpdate];
    
    [_accelerometerObjects removeAllObjects];
    
    [self removeObjects];
    [self removePinsController];
    
    [super willDisappear];
}

-(void) willAppear{
    [super willAppear];
    [self prepareObjectsForSimulation];
    [self populateAccelerometerObjects];
    [self scheduleUpdate];
    [self notifyObjectsSimulationStarted];
    [self addObjects];
    
}

-(NSString*) description{
    return @"Simulator";
}

-(void) dealloc{
    if ([@"YES" isEqualToString: [[[NSProcessInfo processInfo] environment] objectForKey:@"printUIDeallocs"]]) {
        NSLog(@"deallocing %@",self);
    }
}

@end
