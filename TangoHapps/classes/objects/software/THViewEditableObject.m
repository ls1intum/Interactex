//
//  THiPhoneViewEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THViewEditableObject.h"
#import "THiPhoneViewProperties.h"
#import "THView.h"
#import "THEditor.h"

@implementation THViewEditableObject

@dynamic width;
@dynamic height;
@dynamic opacity;
@dynamic position;
@dynamic backgroundColor;

-(void) loadView {

    self.canChangeBackgroundColor = YES;
    
    self.canBeRootView = YES;
    _subviews = [NSMutableArray array];
    self.minSize = kDefaultViewMinSize;
    self.maxSize = kDefaultViewMaxSize;
}

+(id) newView{
    THViewEditableObject * view = [[THViewEditableObject alloc] init];
    view.simulableObject = [[THView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    
    return view;
}

-(id)init {
    self = [super init];
    if(self){
        
        self.canBeResized = YES;
        [self loadView];
        //self.opacity = kUiViewOpacityEditor;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadView];
    self.canChangeBackgroundColor = [decoder decodeBoolForKey:@"canChangeBackgroundColor"];
    //self.subviews = [decoder decodeObjectForKey:@"subviews"];
    self.canBeResized = [decoder decodeBoolForKey:@"canBeResized"];
    
    _subviews = [NSMutableArray array];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeBool:self.canChangeBackgroundColor forKey:@"canChangeBackgroundColor"];
    //[coder encodeObject:self.subviews forKey:@"subviews"];
    [coder encodeBool:self.canBeResized forKey:@"canBeResized"];
}

-(id)copyWithZone:(NSZone *)zone {
    THViewEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers{
    NSMutableArray *controllers = [NSMutableArray array];
    _properties = [THiPhoneViewProperties properties];
    [controllers addObject:_properties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    if(visible != self.visible){
        for (THViewEditableObject * view in _subviews) {
            view.visible = visible;
        }
        [super setVisible:visible];
    }
}

-(CGSize) contentSize{
    THView * view = (THView*) self.simulableObject;
    return CGSizeMake(view.width,view.height);
}

-(void) addSubview:(THViewEditableObject*) object{
    [_subviews addObject:object];
    
    THView * view = (THView*) self.simulableObject;
    [view addSubview:(THView*)object.simulableObject];
}

-(void) removeSubview:(THViewEditableObject*) object{
    [_subviews removeObject:object];
    
    THView * view = (THView*) self.simulableObject;
    [view removeSubview:(THView*)object.simulableObject];
}

-(void) addToLayer:(THEditor*) editor{
    [editor addEditableObject:self];
    
    THView * view = (THView*) self.simulableObject;
    [view addToView:[CCDirector sharedDirector].view];
}

-(void) removeFromLayer:(THEditor*) editor{
    [editor removeEditableObject:self];
    
    THView * view = (THView*) self.simulableObject;
    [view removeFromSuperview];
}

-(UIColor*) backgroundColor{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.backgroundColor;
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.backgroundColor = backgroundColor;
}

-(float) width{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.width;
}

-(void) setWidth:(float)width{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.width = width;
    
    [_properties reloadState];
    
    [super setWidth:width];
}

-(float) height{
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.height;
}

-(void) setHeight:(float)height{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.height = height;
    
    [_properties reloadState];
    
    [super setHeight:height];
}

-(void) displaceBy:(CGPoint)displacement{
    if(!self.canBeRootView){
        displacement = [TFHelper ConvertToCocos2d:displacement];
        self.position = ccpAdd(self.position, displacement);
    }
}

-(void) scaleBy:(float)scale{
    
    if(self.canBeResized){
        THView * iPhoneObject = (THView*) self.simulableObject;
        
        CGPoint origin = iPhoneObject.view.frame.origin;
        CGSize size = iPhoneObject.view.frame.size;
        size = CGSizeMake(size.width*scale, size.height*scale);
        
        iPhoneObject.view.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        [super scaleBy:scale];
    }
}

-(CGRect) boundingBox{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    CGPoint origin = iPhoneObject.view.frame.origin;
    CGSize size = iPhoneObject.view.frame.size;
    origin = [TFHelper ConvertToCocos2dView:origin];
    return CGRectMake(origin.x, origin.y - size.height, size.width, size.height);
}

-(CGPoint) position{
    THView * iPhoneObject = (THView*) self.simulableObject;
    
    if(iPhoneObject.view == nil){
        return [super position];
    } else {
        return iPhoneObject.position;
    }
}

-(CGPoint) absolutePosition{
    CGPoint absPos = [TFHelper ConvertToCocos2dView:self.position];
    return absPos;
}

-(void) setPosition:(CGPoint)position{
    
    CGPoint diff = ccpSub(position,self.position);
    
    [super setPosition:position];
    
    for (THViewEditableObject * subview in _subviews) {
        subview.position = ccpAdd(subview.position,diff);
    }
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.position = position;
}

-(void) setOpacity:(float)opacity{
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.view.alpha = opacity;
}

-(float) opacity{
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.view.alpha;
}

-(void) willStartSimulation{
    self.opacity = 1.0f;
    [super willStartSimulation];
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:self];
}

-(void) removeFromWorld{
    if(!self.canBeRootView){
        
        THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
        [project removeiPhoneObject:self];
        
        NSArray * copy = [NSArray arrayWithArray:_subviews];
        for (THViewEditableObject * view in copy) {
            [view removeFromWorld];
        }
        
        [super removeFromWorld];
    }
}

-(NSString*) description{
    return @"View";
}

-(void) prepareToDie{
    _subviews = nil;
    _properties = nil;
    [super prepareToDie];
}

@end
