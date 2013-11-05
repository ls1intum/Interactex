/*
 THMonitor.m
 Interactex Designer
 
 Created by Juan Haladjian on 04/11/2013.
 
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
 
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "THMonitor.h"
#import "THMonitorLine.h"

@implementation THMonitor

float const kMonitorUpdateFrequency = 0.5f; //monitor updated every 0.5 seconds
float const kMonitorNewValueX = 0.8f;

-(void) loadMonitor{
    
    GLKView * view = [[GLKView alloc] init];
    
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.layer.borderWidth = 1.0f;
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.delegate = self;
    self.view = view;
    
    self.glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //self.glView.context = ((CCGLView*)[CCDirector sharedDirector].view).context;
    self.glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    self.glView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    self.glController = [[GLKViewController alloc] init];
    self.glController.preferredFramesPerSecond = 30;
    self.glController.view = view;
    self.glController.delegate = self;
    self.glController.pauseOnWillResignActive = YES;
    self.glController.paused = YES;
    
    //self.delegate = self;
    //self.preferredFramesPerSecond = 30;
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.lines = [NSMutableArray array];
    
    GLKVector4 colors[2] = {{1, 0, 0, 1},{0, 1, 0, 1}};
    
    THMonitorLine * line = [[THMonitorLine alloc] initWithColor:colors[0]];
    [self.lines addObject:line];
    
    //MonitorLine * line2 = [[MonitorLine alloc] initWithColor:colors[1]];
    //[self.lines addObject:line2];
}

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 200;
        self.height = 200;
        
        [self loadMonitor];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    [self loadMonitor];
    
    //self.image = [decoder decodeObjectForKey:@"image"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    //[coder encodeObject:self.image forKey:@"image"];
}


-(id)copyWithZone:(NSZone *)zone {
    THMonitor * copy = [super copyWithZone:zone];
    
    return copy;
}

#pragma mark - Methods

-(GLKView*) glView{
    return (GLKView*)self.view;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    for (THMonitorLine * line in self.lines) {
        [line render];
    }
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller{
    
    //float pixelsToSeconds = 10;//30 pixels are a second
    updateCounter++;
    
    float timeElapsed = (float)updateCounter / (float)controller.framesPerSecond;
    
    if(timeElapsed >= kMonitorUpdateFrequency){
        
        updateCounter = 0;
        
        for (THMonitorLine * line in self.lines) {
            [line update:timeElapsed];
        }
        
        [self feedMonitor];
    }
}

-(void) feedMonitor{
    
    static int counter = 0;
    
    float y;
    if(counter == 1){
        counter = 0;
        y = 1;
    } else{
        counter = 1;
        y = -1;
    }
    
    THMonitorLine * line = [self.lines objectAtIndex:0];
    [line addPointWithX:kMonitorNewValueX y:y z:1];
}

-(void) start{
    self.glController.paused = NO;
}

-(void) stop{
    self.glController.paused = YES;
}

-(NSString*) description{
    return @"monitor";
}

-(void) willStartSimulating{
    [self start];
    [super willStartSimulating];
}

-(void) prepareToDie{
    
    [super prepareToDie];
    
    if ([EAGLContext currentContext] == self.glView.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

-(void) dealloc{
    NSLog(@"deallocing THMonitor");
}

@end
