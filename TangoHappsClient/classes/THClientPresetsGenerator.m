//
//  THClientFakeSceneDataSource.m
//  TangoHapps
//
//  Created by Juan Haladjian on 3/20/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClientPresetsGenerator.h"
#import "THLilyPad.h"
#import "THLed.h"
#import "THiPhoneButton.h"
#import "THLabel.h"
#import "THBoardPin.h"
#import "THElementPin.h"
#import "THClientScene.h"
#import "THiPhone.h"
#import "THButton.h"
#import "THBuzzer.h"
#import "THTouchpad.h"
#import "THLightSensor.h"
#import "THCompass.h"
#import "THClientProject.h"

@implementation THClientPresetsGenerator

NSString * const kDigitalOutputSceneName = @"Digital Output";
NSString * const kDigitalInputSceneName = @"Digital Input";
NSString * const kBuzzerSceneName = @"Buzzer";
NSString * const kAnalogOutputSceneName = @"Analog Output";
NSString * const kAnalogInputSceneName = @"Analog Input";
NSString * const kCompassSceneName = @"Compass";

-(id) init{
    
    self = [super init];
    if(self){
        _scenes = [NSMutableArray array];       
        
        THClientScene * scene1 = [[THClientScene alloc] initWithName:kDigitalOutputSceneName];
        THClientScene * scene2 = [[THClientScene alloc] initWithName:kDigitalInputSceneName];
        THClientScene * scene3 = [[THClientScene alloc] initWithName:kBuzzerSceneName];
        THClientScene * scene4 = [[THClientScene alloc] initWithName:kAnalogOutputSceneName];
        THClientScene * scene5 = [[THClientScene alloc] initWithName:kAnalogInputSceneName];
        THClientScene * scene6 = [[THClientScene alloc] initWithName:kCompassSceneName];
        
        [self.scenes addObject:scene1];
        [self.scenes addObject:scene2];
        [self.scenes addObject:scene3];
        [self.scenes addObject:scene4];
        [self.scenes addObject:scene5];
        [self.scenes addObject:scene6];
        
        for (THClientScene * scene in self.scenes) {
            scene.isFakeScene = YES;
        }

    }
    return self;
}

-(THClientProject*) projectNamed:(NSString *)name{
    
    if([name isEqualToString:kDigitalOutputSceneName]){
        return [self digitalOutputProject];
    } else if([name isEqualToString:kDigitalInputSceneName]){
        return [self digitalInputProject];
    } else if([name isEqualToString:kBuzzerSceneName]){
        return [self buzzerProject];
    } else if([name isEqualToString:kAnalogOutputSceneName]){
        return [self analogOutputProject];
    } else if([name isEqualToString:kAnalogInputSceneName]){
        return [self analogInputProject];
    } else if([name isEqualToString:kCompassSceneName]){
        return [self compassProject];
    }
    return nil;
}

-(THClientProject*) defaultClientProject{
    
    THClientProject * project = [THClientProject emptyProject];
    project.iPhone = [[THiPhone alloc] init];
    project.iPhone.currentView = [[THView alloc] init];
    project.iPhone.currentView.backgroundColor = [UIColor whiteColor];
    return project;
}

-(THClientProject*) digitalOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObject:led];
    
    THiPhoneButton * button = [[THiPhoneButton alloc] init];
    button.text = @"turnOn";
    button.position = CGPointMake(100, 200);
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 200);
    
    
    TFMethod * method = [led methodNamed:@"turnOn"];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:led method:method];
    TFEvent * event = [button.events objectAtIndex:0];
    turnOn.source = button;
    [project registerAction:turnOn forEvent:event];
    
    TFMethod * method2 = [led methodNamed:@"turnOff"];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:led method:method2];
    TFEvent * event2 = [button.events objectAtIndex:0];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event2];
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 5";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label,nil];
    
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:5];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    [project save];
    
    
    return project;
}

-(THClientProject*) digitalInputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    THLed * led = [[THLed alloc] init];
    THButton * lilybutton = [[THButton alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:led, lilybutton,nil];
    
    THiPhoneButton * button = [[THiPhoneButton alloc] init];
    button.text = @"turnOn";
    button.position = CGPointMake(100, 200);
    
    TFMethod * method = [led.methods objectAtIndex:2];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:led method:method];
    TFEvent * event = [button.events objectAtIndex:0];
    turnOn.source = button;
    [project registerAction:turnOn forEvent:event];
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 200);
    
    TFMethod * method2 = [led.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:led method:method2];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event];
    
    TFMethod * method3 = [led.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff2 = [[TFMethodInvokeAction alloc] initWithTarget:led method:method3];
    turnOff2.source = lilybutton;
    TFEvent * event2 = [lilybutton.events objectAtIndex:0];
    [project registerAction:turnOff2 forEvent:event2];
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 5 and a button to pin 4";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    label.height = 100;
    label.numLines = 2;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label, nil];
    
    //pins
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:5];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    THBoardPin * lilypinButton = [lilypad digitalPinWithNumber:4];
    lilypinButton.mode = kPinModeDigitalInput;
    THElementPin * buttonpin = [lilybutton.pins objectAtIndex:0];
    [lilypinButton attachPin:buttonpin];
    [buttonpin attachToPin:lilypinButton];
    
    return project;
}

-(THClientProject*) buzzerProject{
    
    THClientProject * project = [self defaultClientProject];
    
    THBuzzer * buzzer = [[THBuzzer alloc] init];
    
    project.hardwareComponents = [NSMutableArray arrayWithObject:buzzer];
    
    THiPhoneButton * button1 = [[THiPhoneButton alloc] init];
    button1.text = @"turnOn";
    button1.position = CGPointMake(100, 150);
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 150);
    
    THTouchpad * touchpad = [[THTouchpad alloc] init];
    touchpad.position = CGPointMake(150, 300);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Buzzer to pin 9";
    label.position = CGPointMake(150, 50);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button1, button2, touchpad, label, nil];
    
    TFEvent * event = [button1.events objectAtIndex:0];
    
    TFMethod * turnOnMethod = [buzzer.methods objectAtIndex:2];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:buzzer method:turnOnMethod];
    turnOn.source = button1;
    [project registerAction:turnOn forEvent:event];
    
    TFMethod * turnOffMethod = [buzzer.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:buzzer method:turnOffMethod];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event];
    
    TFEvent * dxEvent = [touchpad.events objectAtIndex:0];
    TFMethod * varyFreqMethod = [buzzer.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:buzzer method:varyFreqMethod];
    TFProperty * property = [touchpad.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:touchpad];
    methodInvoke.source = touchpad;
    [project registerAction:methodInvoke forEvent:dxEvent];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    
    THBoardPin * lilypinBuzzer = [lilypad digitalPinWithNumber:9];
    lilypinBuzzer.mode = kPinModeBuzzer;
    THElementPin * buzzerPin = [buzzer.pins objectAtIndex:0];
    [lilypinBuzzer attachPin:buzzerPin];
    [buzzerPin attachToPin:lilypinBuzzer];
        
    return project;
}

-(THClientProject*) analogOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:led,nil];
    
    //pins
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:9];
    lilypinled.mode = kPinModePWM;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    THTouchpad * touchpad = [[THTouchpad alloc] init];
    touchpad.position = CGPointMake(150, 200);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 9";
    label.position = CGPointMake(150, 50);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:touchpad,label,nil];
    
    TFEvent * dxEvent = [touchpad.events objectAtIndex:0];
    TFMethod * varyIntensityMethod = [led.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:led method:varyIntensityMethod];
    TFProperty * property = [touchpad.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:touchpad];
    methodInvoke.source = touchpad;
    [project registerAction:methodInvoke forEvent:dxEvent];
    
    return project;
}

-(THClientProject*) analogInputProject{
    THClientProject * project = [self defaultClientProject];
    
    THLightSensor * lightSensor = [[THLightSensor alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:lightSensor,nil];
    
    THLabel * sensorLabel = [[THLabel alloc] init];
    sensorLabel.position = CGPointMake(150, 200);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Light Sensor to analog pin 0";
    label.position = CGPointMake(170, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:label,sensorLabel,nil];
    
    //method
    TFEvent * lightChangeEvent = [lightSensor.events objectAtIndex:0];
    TFMethod * setTextMethod = [sensorLabel.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:sensorLabel method:setTextMethod];
    TFProperty * property = [lightSensor.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:lightSensor];
    methodInvoke.source = lightSensor;
    [project registerAction:methodInvoke forEvent:lightChangeEvent];
    
    //pins
    THBoardPin * lilypinLightSensor = [lilypad analogPinWithNumber:0];
    lilypinLightSensor.mode = kPinModeAnalogInput;
    THElementPin * lightSensorPin = [lightSensor.pins objectAtIndex:1];
    [lilypinLightSensor attachPin:lightSensorPin];
    [lightSensorPin attachToPin:lilypinLightSensor];
    
    return project;
}

-(THClientProject*) compassProject{
    
    THClientProject * project = [self defaultClientProject];
    /*
    THCompass * compass = [[THCompass alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSArray arrayWithObjects:compass,nil];
    
    THLabel * label1 = [[THLabel alloc] init];
    label1.position = CGPointMake(100, 150);
    
    THLabel * label2 = [[THLabel alloc] init];
    label2.position = CGPointMake(200, 150);
    
    THLabel * label3 = [[THLabel alloc] init];
    label3.position = CGPointMake(150, 250);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Compass to the I2C pins";
    label.position = CGPointMake(150, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSArray arrayWithObjects:label1,label2,label3,label,nil];
    
    //method x
    TFEvent * xEvent = [compass.events objectAtIndex:0];
    TFMethod * setTextMethod = [label1.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke1 = [TFMethodInvokeAction actionWithTarget:label1 method:setTextMethod];
    TFProperty * property1 = [compass.viewableProperties objectAtIndex:0];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property1 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke1 forEvent:xEvent];
    
    //method y
    TFEvent * yEvent = [compass.events objectAtIndex:1];
    TFMethod * setTextMethod2 = [label2.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke2 = [TFMethodInvokeAction actionWithTarget:label2 method:setTextMethod2];
    TFProperty * property2 = [compass.viewableProperties objectAtIndex:1];
    methodInvoke2.firstParam = [TFPropertyInvocation invocationWithProperty:property2 target:compass];
    methodInvoke2.source = compass;
    [project registerAction:methodInvoke2 forEvent:yEvent];
    
    //heading
    TFEvent * headingEvent = [compass.events objectAtIndex:1];
    TFMethod * setTextMethod3 = [label3.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke3 = [TFMethodInvokeAction actionWithTarget:label3 method:setTextMethod3];
    TFProperty * property3 = [compass.viewableProperties objectAtIndex:3];
    methodInvoke3.firstParam = [TFPropertyInvocation invocationWithProperty:property3 target:compass];
    methodInvoke3.source = compass;
    [project registerAction:methodInvoke3 forEvent:headingEvent];
    
    //pins
    THElementPin * compassPin = compass.pin5;
    THBoardPin * pin5 = [lilypad analogPinWithNumber:5];
    NSLog(@"");
    [pin5 attachPin:compassPin];
    [compassPin attachToPin:pin5];
    */
    return project;
}

-(NSInteger) numFakeScenes{
    return _scenes.count;
}

@end
