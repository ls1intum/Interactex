/*
HActivityRecognition.m
 Interactex Designer
 
 Created by Juan Haladjian on 16/03/15.
 
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

#import "THActivityRecognition.h"

@implementation THActivityRecognition

-(id) init{
    self = [super init];
    if(self){
        [self loadActivityRecognition];
        
    }
    return self;
}

-(void) loadActivityRecognition{
    
    TFMethod * method = [TFMethod methodWithName:@"addSample"];
    method.numParams = 1;
    method.firstParamType = kDataTypeAny;
    
    self.methods = [NSMutableArray arrayWithObjects:method,nil];
    
    TFEvent * event1 = [TFEvent eventNamed:kEventStanding];
    TFEvent * event2 = [TFEvent eventNamed:kEventWalking];
    TFEvent * event3 = [TFEvent eventNamed:kEventRunning];
    TFEvent * event4 = [TFEvent eventNamed:kEventUnconscious];
    
    self.events = [NSMutableArray arrayWithObjects:event1,event2,event3,event4,nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        [self loadActivityRecognition];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
}

-(id)copyWithZone:(NSZone *)zone {
    THActivityRecognition * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(THAccelerometerData*) computeMean{
    
    THAccelerometerData * mean = [[THAccelerometerData alloc] init];
    
    for(int i = 0 ; i < count; i++){
        mean.x += buffer[i].x;
        mean.y += buffer[i].y;
        mean.z += buffer[i].z;

    }
    
    mean.x = mean.x / (float) count;
    mean.y = mean.y / (float) count;
    mean.z = mean.z / (float) count;
    
    return mean;
}

-(THAccelerometerData*) computeDeviationUsingMena:(THAccelerometerData*) mean{
    
    THAccelerometerData * deviation = [[THAccelerometerData alloc] init];
    
    deviation.x = 0;
    deviation.y = 0;
    deviation.z = 0;
    
    double diff;
    for(int i = 0 ; i < count ; i++){
        
        diff = buffer[i].x - mean.x;
        deviation.x += diff * diff;
        
        diff = buffer[i].y - mean.y;
        deviation.y += diff * diff;
        
        diff = buffer[i].z - mean.z;
        deviation.z += diff * diff;
    }
    
    deviation.x = sqrt(deviation.x / (count-1));
    deviation.y = sqrt(deviation.y / (count-1));
    deviation.z = sqrt(deviation.z / (count-1));
    
    return deviation;
}

-(ActivityState) classify{
    
    THAccelerometerData * mean = [self computeMean];
    THAccelerometerData * deviation = [self computeDeviationUsingMena:mean];
    
    if(mean.z > 0.67 || mean.z < 0.3){
        return kActivityStateUnconscious;
    }
    
    double magnitude = sqrt(deviation.x * deviation.x + deviation.y * deviation.y + deviation.z * deviation.z);
        
    if(magnitude < 0.02){
        
        return kActivityStateStanding;
        
    } else if(magnitude > 0.20){
        
        return kActivityStateRunning;
        
    } else {
        return kActivityStateWalking;
    }
}

-(void) addSample:(THAccelerometerData*) value{
    
    //NSLog(@"adding %f %f %f",value.x,value.y,value.z);
    
    buffer[count] = value;
    count++;
    if(count >= kActivityRecognitionNumSamples){
        
        ActivityState state = [self classify];
        
        switch (state) {
            case kActivityStateStanding:
                
                [self triggerEventNamed:kEventStanding];
                break;
                
            case kActivityStateWalking:
                
                [self triggerEventNamed:kEventWalking];
                break;
            case kActivityStateRunning:
                
                [self triggerEventNamed:kEventRunning];
                break;
                
            case kActivityStateUnconscious:
                
                [self triggerEventNamed:kEventUnconscious];
                break;
        }
        
        count = 0;
    }
}

-(void) didStartSimulating{
    count = 0;
    //[self triggerEventNamed:kEventDeviationChanged];
    [super didStartSimulating];
}

-(NSString*) description{
    return @"activityClassifier";
}


@end
