//
//  THPotentiometerEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/8/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPotentiometerEditableObject.h"
#import "THPotentiometer.h"
#import "THPotentiometerProperties.h"

@implementation THPotentiometerEditableObject

@dynamic value;
@dynamic minValueNotify;
@dynamic maxValueNotify;
@dynamic notifyBehavior;

-(void) loadPotentiometer{
    self.sprite = [CCSprite spriteWithFile:@"potentiometer.png"];
    [self addChild:self.sprite];
    
    CGSize size = CGSizeMake(75, 20);
    _valueLabel = [CCLabelTTF labelWithString:@"" dimensions:size alignment:NSTextAlignmentCenter fontName:kSimulatorDefaultFont fontSize:11];
    _valueLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2-50);
    _valueLabel.visible = NO;
    [self addChild:_valueLabel z:1];
    
    self.acceptsConnections = YES;
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THPotentiometer alloc] init];
        
        self.type = kHardwareTypePotentiometer;
        
        [self loadPotentiometer];
        [self loadPins];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadPotentiometer];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THPotentiometerEditableObject * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[THPotentiometerProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Pins

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) analogPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) plusPin{
    return [self.pins objectAtIndex:2];
}

#pragma mark - Methods

-(void) handleTouchBegan{
    self.isDown = YES;
}

-(void) handleTouchEnded{
    self.isDown = NO;
}

-(void) update{
    
    if(self.isDown){
        _touchDownIntensity += 2.0f;
    } else {
        _touchDownIntensity -= 1.0f;
    }
    _touchDownIntensity = [THClientHelper Constrain:_touchDownIntensity min:0 max:kMaxPotentiometerValue];
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.value = _touchDownIntensity;
    _valueLabel.string = [NSString stringWithFormat:@"%d",potentiometer.value];
    //potentiometer.opacity = _touchDownIntensity;
}

-(NSInteger) value{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.value;
}

-(NSInteger) minValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.minValueNotify;
}

-(void) setMinValueNotify:(NSInteger)minValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.minValueNotify = minValueNotify;
}

-(NSInteger) maxValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.maxValueNotify;
}

-(void) setMaxValueNotify:(NSInteger)maxValueNotify{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.maxValueNotify = maxValueNotify;
}

-(THSensorNotifyBehavior) notifyBehavior{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    return potentiometer.notifyBehavior;
}

-(void) setNotifyBehavior:(THSensorNotifyBehavior)notifyBehavior{
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    potentiometer.notifyBehavior = notifyBehavior;
}

-(void) handleRotation:(float) degree{
    
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    _value += degree*10;

    _value = [THClientHelper Constrain:_value min:0 max:kMaxPotentiometerValue];
    potentiometer.value = (NSInteger) _value;
}

-(void) willStartEdition{
    _valueLabel.visible = NO;
}

-(void) willStartSimulation{
    THPotentiometer * potentiometer = (THPotentiometer*) self.simulableObject;
    _value = potentiometer.value;
    _valueLabel.visible = YES;
    
    [super willStartSimulation];
}

-(NSString*) description{
    return @"Potentiometer";
}

@end
