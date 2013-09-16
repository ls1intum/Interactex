//
//  THSlider.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/9/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSlider.h"

@implementation THSlider

@dynamic value;
@dynamic min;
@dynamic max;

-(void) loadSliderView{
    
    UISlider * slider = [[UISlider alloc] init];
    //view.backgroundColor = [UIColor colorWithRed:0.88 green:0.69 blue:0.48 alpha:1];
    slider.frame = CGRectMake(0, 0, self.width, self.height);
    self.view = slider;
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = NO;
    
    TFProperty * valueProperty = [TFProperty propertyWithName:@"value" andType:kDataTypeFloat];
    self.properties = [NSMutableArray arrayWithObjects:valueProperty,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventValueChanged];
    event1.param1 = [TFPropertyInvocation invocationWithProperty:valueProperty target:self];
    self.events = [NSArray arrayWithObjects:event1, nil];
    
    [slider addTarget:self action:@selector(handleValueChanged) forControlEvents:UIControlEventValueChanged];
}

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 150;
        self.height = 30;
        
        self.position = CGPointZero;
        
        [self loadSliderView];
        
        self.min = 0;
        self.max = 255;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadSliderView];
    
    self.value = [decoder decodeFloatForKey:@"value"];
    self.min = [decoder decodeFloatForKey:@"min"];
    self.max = [decoder decodeFloatForKey:@"max"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeFloat:self.value forKey:@"value"];
    [coder encodeFloat:self.min forKey:@"min"];
    [coder encodeFloat:self.max forKey:@"max"];
}

-(id)copyWithZone:(NSZone *)zone {
    THSlider * copy = [super copyWithZone:zone];
    
    copy.value = self.value;
    copy.min = self.min;
    copy.max = self.max;
    
    return copy;
}

#pragma mark - Methods

-(float) value{
    return ((UISlider*)self.view).value;
}

-(void) setValue:(float)value{
    ((UISlider*)self.view).value = value;
}

-(float) min{
    return ((UISlider*)self.view).minimumValue;
}

-(void) setMin:(float)min{
    ((UISlider*)self.view).minimumValue = min;
}

-(float) max{
    return ((UISlider*)self.view).maximumValue;
}

-(void) setMax:(float)max{
    ((UISlider*)self.view).maximumValue = max;
}


-(void) handleValueChanged{

    [self triggerEventNamed:kEventValueChanged];
}

-(void) didStartSimulating{
    
    [self triggerEventNamed:kEventValueChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"slider";
}

@end
