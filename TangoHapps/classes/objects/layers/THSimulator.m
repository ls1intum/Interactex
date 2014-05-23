/*
THSimulator.m
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
#import "THHardwareComponentEditableObject.h"

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

/*
-(void) accelerated:(UIAcceleration*) acceleration{
    for (TFEditableObject * object in _accelerometerObjects) {
        [object handleAccelerated:acceleration];
    }
}*/


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
    
    //CGPoint location = [sender locationInView:sender.view];
    //location = [self toLayerCoords:location];
    
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
        if([object isKindOfClass:[THHardwareComponentEditableObject class]]){
            THHardwareComponentEditableObject * hardwareComponent = (THHardwareComponentEditableObject*) object;
            if(!hardwareComponent.attachedToClothe && !hardwareComponent.attachedToGesture){
                [object addToLayer:self];
            }
        }else {
            [object addToLayer:self];
        }
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
