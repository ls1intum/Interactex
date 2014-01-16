/*
THClientPresetsGenerator.m
Interactex Client

Created by Juan Haladjian on 10/07/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THClientPresetsGenerator.h"
#import "THLilyPad.h"
#import "THLed.h"
#import "THiPhoneButton.h"
#import "THLabel.h"
#import "THBoardPin.h"
#import "THElementPin.h"
#import "THiPhone.h"
#import "THButton.h"
#import "THBuzzer.h"
#import "THTouchpad.h"
#import "THLightSensor.h"
#import "THCompassLSM303.h"
#import "THClientProject.h"
#import "THClientProjectProxy.h"
#import "THI2CRegister.h"
#import "THMonitor.h"
#import "THMusicPlayer.h"

@implementation THClientPresetsGenerator

NSString * const kDigitalOutputProjectName = @"Digital Output";
NSString * const kDigitalInputProjectName = @"Digital Input";
NSString * const kBuzzerProjectName = @"Buzzer";
NSString * const kAnalogOutputProjectName = @"Analog Output";
NSString * const kAnalogInputProjectName = @"Analog Input";
NSString * const kMCUCompassProjectName = @"MCU";
NSString * const kLSMCompassProjectName = @"LSM";
NSString * const kMusicPlayerProjectName = @"Music Player";

-(id) init{
    
    self = [super init];
    if(self){
       
        
    }
    return self;
}
/*
-(void) loadPresets{
    
    NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
    _presets = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}*/

-(void) generatePresets{
    
    _presets = [NSMutableArray array];
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:[self digitalOutputProject]];
    [array addObject:[self digitalInputProject]];
    [array addObject:[self buzzerProject]];
    [array addObject:[self analogInputProject]];
    [array addObject:[self lsmProject]];
    [array addObject:[self mcuProject]];
    [array addObject:[self musicPlayerProject]];
    
    
    NSMutableArray * imagesArray = [NSMutableArray array];
    [imagesArray addObject:[UIImage imageNamed:@"led.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"button.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"buzzer.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"lightSensor.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"LSMCompass.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"accelerometer.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"musicPlayer.png"]];
    
    for (int i = 0 ; i < array.count ; i++) {
        
        THClientProject * project = [array objectAtIndex:i];
        [project saveToDirectory:kPresetsDirectory];
        
        THClientProjectProxy * proxy = [[THClientProjectProxy alloc] initWithName:project.name];
        
        UIImage * image = [imagesArray objectAtIndex:i];
        proxy.image = image;
        
        [_presets addObject:proxy];
    }
}

/*
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
}*/

-(THClientProject*) defaultClientProject{
    
    THClientProject * project = [THClientProject emptyProject];
    project.iPhone = [[THiPhone alloc] init];
    project.iPhone.currentView = [[THView alloc] init];
    project.iPhone.currentView.backgroundColor = [UIColor whiteColor];
    return project;
}

-(THClientProject*) digitalOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kDigitalOutputProjectName;
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
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
    label.text = @"connect a LED to pin 4";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label,nil];
    
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:4];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    return project;
}

-(THClientProject*) digitalInputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kDigitalInputProjectName;
    
    THLed * led = [[THLed alloc] init];
    THButton * lilybutton = [[THButton alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.boards = [NSMutableArray arrayWithObject:lilypad];

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
    label.text = @"LED to pin 4, button to pin 5";
    label.position = CGPointMake(170, 100);
    label.width = 240;
    label.height = 80;
    label.numLines = 2;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label, nil];
    
    //pins
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:4];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    THBoardPin * lilypinButton = [lilypad digitalPinWithNumber:5];
    lilypinButton.mode = kPinModeDigitalInput;
    THElementPin * buttonpin = [lilybutton.pins objectAtIndex:0];
    [lilypinButton attachPin:buttonpin];
    [buttonpin attachToPin:lilypinButton];
    
    return project;
}

-(THClientProject*) buzzerProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kBuzzerProjectName;
    
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
    label.text = @"connect a Buzzer to pin 10";
    label.position = CGPointMake(150, 50);
    label.width = 250;
    
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
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
    THBoardPin * lilypinBuzzer = [lilypad digitalPinWithNumber:10];
    lilypinBuzzer.mode = kPinModePWM;
    THElementPin * buzzerPin = [buzzer.pins objectAtIndex:0];
    [lilypinBuzzer attachPin:buzzerPin];
    [buzzerPin attachToPin:lilypinBuzzer];
        
    return project;
}

-(THClientProject*) analogOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kAnalogOutputProjectName;
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
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
    
    project.name = kAnalogInputProjectName;
    
    THLightSensor * lightSensor = [[THLightSensor alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
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

-(THClientProject*) mcuProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kMCUCompassProjectName;
    
    THCompassLSM303 * compass = [[THCompassLSM303 alloc] init];
    
    compass.i2cComponent = [[THI2CComponent alloc] init];
    THI2CRegister * reg = [[THI2CRegister alloc] init];
    
    compass.i2cComponent.address = 104;
    reg.number = 0x3B;
    
    [compass.i2cComponent addRegister:reg];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    
    [lilypad addI2CComponent:compass];
    
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
    project.hardwareComponents = [NSMutableArray arrayWithObjects:compass,nil];
    
    THMonitor * monitor = [[THMonitor alloc] init];
    monitor.position = CGPointMake(160, 250);
    monitor.maxValue = 5000;
    monitor.minValue = -5000;
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect an MCU Compass";
    label.position = CGPointMake(160, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:monitor,label,nil];
    
    //method x
    TFEvent * xEvent = [compass.events objectAtIndex:0];
    TFMethod * addValue1Method = [monitor.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke1 = [TFMethodInvokeAction actionWithTarget:monitor method:addValue1Method];
    TFProperty * property1 = [compass.properties objectAtIndex:0];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property1 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke1 forEvent:xEvent];
    
    //method y
    TFEvent * yEvent = [compass.events objectAtIndex:1];
    TFMethod * addValue2Method = [monitor.methods objectAtIndex:1];
    TFMethodInvokeAction * methodInvoke2 = [TFMethodInvokeAction actionWithTarget:monitor method:addValue2Method];
    TFProperty * property2 = [compass.properties objectAtIndex:1];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property2 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke2 forEvent:yEvent];
    
    //pins
    [lilypad.sclPin attachPin:compass.sclPin];
    [lilypad.sdaPin attachPin:compass.sdaPin];
    
    [compass.sclPin attachToPin:lilypad.sclPin];
    [compass.sdaPin attachToPin:lilypad.sdaPin];
    
    return project;
}

-(THClientProject*) lsmProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kLSMCompassProjectName;
    
    THCompassLSM303 * compass = [[THCompassLSM303 alloc] init];
    
    compass.i2cComponent = [[THI2CComponent alloc] init];
    THI2CRegister * reg = [[THI2CRegister alloc] init];
    
    compass.i2cComponent.address = 24;
    reg.number = 168;
    
    [compass.i2cComponent addRegister:reg];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    
    [lilypad addI2CComponent:compass];
    
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
    project.hardwareComponents = [NSMutableArray arrayWithObjects:compass,nil];
    
    THMonitor * monitor = [[THMonitor alloc] init];
    monitor.position = CGPointMake(160, 250);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect an LSM Compass";
    label.position = CGPointMake(160, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:monitor,label,nil];
    
    //method x
    TFEvent * xEvent = [compass.events objectAtIndex:0];
    TFMethod * addValue1Method = [monitor.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke1 = [TFMethodInvokeAction actionWithTarget:monitor method:addValue1Method];
    TFProperty * property1 = [compass.properties objectAtIndex:0];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property1 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke1 forEvent:xEvent];
    
    //method y
    TFEvent * yEvent = [compass.events objectAtIndex:1];
    TFMethod * addValue2Method = [monitor.methods objectAtIndex:1];
    TFMethodInvokeAction * methodInvoke2 = [TFMethodInvokeAction actionWithTarget:monitor method:addValue2Method];
    TFProperty * property2 = [compass.properties objectAtIndex:1];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property2 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke2 forEvent:yEvent];
    
    //pins
    [lilypad.sclPin attachPin:compass.sclPin];
    [lilypad.sdaPin attachPin:compass.sdaPin];
    
    [compass.sclPin attachToPin:lilypad.sclPin];
    [compass.sdaPin attachToPin:lilypad.sdaPin];
    
    return project;
}

-(THClientProject*) musicPlayerProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kMusicPlayerProjectName;
    
    //board
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.boards = [NSMutableArray arrayWithObject:lilypad];
    
    //lilypad
    THButton * lilybutton = [[THButton alloc] init];
    project.hardwareComponents = [NSMutableArray arrayWithObjects:lilybutton,nil];
    
    //iphone objects
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Button pin 5";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    label.height = 100;
    label.numLines = 2;
    
    THMusicPlayer * musicPlayer = [[THMusicPlayer alloc] init];
    musicPlayer.position = CGPointMake(180, 400);
    
    THiPhoneButton * button = [[THiPhoneButton alloc] init];
    button.text = @"Stop";
    button.position = CGPointMake(180, 200);
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:label,button,musicPlayer, nil];
    
    //play action
    TFMethod * playMethod = [musicPlayer.methods objectAtIndex:0];
    TFMethodInvokeAction * playAction = [[TFMethodInvokeAction alloc] initWithTarget:musicPlayer method:playMethod];
    TFEvent * event = [lilybutton.events objectAtIndex:0];
    playAction.source = lilybutton;
    [project registerAction:playAction forEvent:event];
    
    //stop playing action
    TFMethod * stopPlaying = [musicPlayer.methods objectAtIndex:1];
    TFMethodInvokeAction * stopPlayingAction = [[TFMethodInvokeAction alloc] initWithTarget:musicPlayer method:stopPlaying];
    event = [button.events objectAtIndex:0];
    stopPlayingAction.source = button;
    [project registerAction:stopPlayingAction forEvent:event];
    
    //pins
    THBoardPin * lilypinButton = [lilypad digitalPinWithNumber:5];
    lilypinButton.mode = kPinModeDigitalInput;
    THElementPin * buttonpin = [lilybutton.pins objectAtIndex:0];
    [lilypinButton attachPin:buttonpin];
    [buttonpin attachToPin:lilypinButton];
    
    return project;
}

-(NSInteger) numFakeScenes{
    return _presets.count;
}

@end
