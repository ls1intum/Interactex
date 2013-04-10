//
//  THLedProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLedProperties.h"
#import "THLed.h"
#import "THLedEditableObject.h"

@implementation THLedProperties
@synthesize onSwitch;

static THLedProperties *_sharedInstance = nil;

+(id)sharedInstance
{
    if(_sharedInstance == nil)
        _sharedInstance = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSString*) title{
    return @"Led";
}

-(void) updateIntensityLabel{
    
    THLedEditableObject * led = (THLedEditableObject*) self.editableObject;
    self.intensityLabel.text = [NSString stringWithFormat: @"%d", led.intensity];
}

-(void) reloadState{
    
    THLedEditableObject * led = (THLedEditableObject*) self.editableObject;
    
    self.onSwitch.on = led.onAtStart;
    self.intensitySlider.value = led.intensity;
    [self updateIntensityLabel];
}

- (IBAction)onChanged:(id)sender {
    THLedEditableObject * led = (THLedEditableObject*) self.editableObject;
    led.onAtStart = self.onSwitch.on;
}

- (IBAction)intensityChanged:(id)sender {
    
    THLedEditableObject * led = (THLedEditableObject*) self.editableObject;
    
    float intensity = self.intensitySlider.value;
    led.intensity = intensity;
    [self updateIntensityLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOnSwitch:nil];
    [self setIntensitySlider:nil];
    [self setIntensityLabel:nil];
    [super viewDidUnload];
}



@end
