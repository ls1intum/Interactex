//
//  THiPhoneEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/19/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneEditableObject.h"
#import "THiPhoneProperties.h"
#import "THView.h"
#import "THViewEditableObject.h"
#import "THiPhone.h"
#import "THViewEditableObject.h"
#import "THView.h"
#import "THCustomEditor.h"

@implementation THiPhoneEditableObject
@dynamic type;

-(void) reloadiPhoneSprite{
    self.z = kiPhoneZ;
    
    if(self.sprite != nil){
        [self.sprite removeFromParentAndCleanup:YES];
    }
    NSString * fileName = (self.type == kiPhoneType4S) ? @"iphone4.png" : @"iphone5.png";
    self.sprite = [CCSprite spriteWithFile:fileName];
    [self addChild:self.sprite z:kiPhoneZ];
}

-(void) loadSprite{
    
    [self reloadiPhoneSprite];
    
    self.z = kiPhoneZ;
    self.zoomable = NO;
    self.canBeDuplicated = NO;
}

+(id) iPhoneWithDefaultView{
    
    THiPhoneEditableObject * iPhone = [[THiPhoneEditableObject alloc] init];
    THViewEditableObject * view = [THViewEditableObject newView];
    view.opacity = kUiViewOpacityEditor;
    view.canBeResized = NO;
    iPhone.currentView = view;
    return iPhone;
}

-(id) init{
    self = [super init];
    if(self){
        
        self.simulableObject = [[THiPhone alloc] init];
        [self loadSprite];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        
        
        _currentView = [decoder decodeObjectForKey:@"currentView"];
        _currentView.canBeDuplicated = NO;
        [self addChild:_currentView];
        
        [self loadSprite];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_currentView forKey:@"currentView"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THiPhone * copy = [super copyWithZone:zone];
    copy.currentView = [_currentView copy];
    copy.position = self.position;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THiPhoneProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    self.currentView.visible = visible;
    [super setVisible:visible];
}

-(void) adaptViewSizeToIphoneType{
    self.currentView.width = kiPhoneFrames[self.type].size.width;
    self.currentView.height = kiPhoneFrames[self.type].size.height;
}

-(void) setType:(THIPhoneType)type{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.type = type;
    [self reloadiPhoneSprite];
    [self adaptViewSizeToIphoneType];
    [self updateBoxes];
}

-(THIPhoneType) type{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    return iPhone.type;
}

-(void) removeFromSuperview{
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone removeFromSuperview];
}

-(void) addToView:(UIView*) aView{
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone addToView:aView];
}

-(void) addToLayer:(TFLayer*) layer{
    [layer addEditableObject:self];
    
    [(THiPhone*)self.simulableObject addToView:[[CCDirector sharedDirector] openGLView]];
}

-(void) removeFromLayer:(TFLayer *)layer{
    [layer removeEditableObject:self];
}

-(void) setCurrentView:(THViewEditableObject *)currentView{
    
    if(currentView != nil){
        CGRect frame = kiPhoneFrames[self.type];
        currentView.width = frame.size.width;
        currentView.height = frame.size.height;
        
        [self centerView:currentView];
        [self addChild:currentView];
    }
    
    _currentView = currentView;
    _currentView.canBeDuplicated = NO;
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.currentView = (THView*) currentView.simulableObject;
}

-(void) centerView:(THViewEditableObject*) view{
    
    CGRect frame = kiPhoneFrames[self.type];
    CGRect box = self.boundingBox;
    CGPoint topleft = box.origin;
    topleft.y += box.size.height;
    CGPoint viewtopleft = ccpAdd(topleft, ccp(frame.origin.x,-frame.origin.y));
    CGPoint viewcenter = ccpAdd(viewtopleft, ccp(frame.size.width/2,-frame.size.height/2));
    viewcenter = [TFHelper ConvertToCocos2dView:viewcenter];
    view.position = viewcenter;
}

-(void) setPosition:(CGPoint)position{
    
    [super setPosition:position];
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.position = [TFHelper ConvertToCocos2dView:self.position];
    
    CGPoint pos = [TFHelper ConvertToCocos2dView:self.position];
    
    _currentView.position = pos;
}

/*
-(void) setPosition:(CGPoint)position{
    
    CGPoint displacement = ccpSub(position,self.position);
    
    [super setPosition:position];
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.position = [TFHelper ConvertToCocos2dView:self.position];
    
    [_currentView displaceBy:displacement];
}*/

-(void) displaceBy:(CGPoint)displacement{
    
    [super displaceBy:displacement];
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    iPhone.position = [TFHelper ConvertToCocos2dView:self.position];
}

-(void) scaleBy:(float)scale{
    
}

-(void) addToWorld{
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project addiPhone:self];
}

-(void) removeFromWorld{
    //[_currentView removeFromWorld];
    
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    [project removeiPhone];
    
    [super removeFromWorld];
}

-(void) makeEmergencyCall{
    
    THiPhone * iPhone = (THiPhone*) self.simulableObject;
    [iPhone makeEmergencyCall];
}

-(NSString*) description{
    return @"iPhone";
}

-(void) draw{
    glPointSize(10);
    [self convertToWorldSpace:ccp(0,0)];
}

-(void) willStartEdition{
    
    self.currentView.opacity = kUiViewOpacityEditor;
    [self.currentView willStartEdition];
    [super willStartEdition];
}

-(void) willStartSimulation{
    self.currentView.opacity = 1.0f;
    [super willStartSimulation];
}

-(void) prepareToDie{
    
    [_currentView prepareToDie];
    _currentView = nil;
    
    [self removeFromSuperview];
    [super prepareToDie];
}

@end
