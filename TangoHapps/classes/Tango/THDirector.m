/*
THDirector.m
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

#import "TFLayer.h"
#import "THTabbarViewController.h"
#import "THPropertiesViewController.h"

#import "THDirector.h"
#import "THProjectProxy.h"
#import "THProjectViewController.h"
#import "THServerController.h"
#import "THCustomComponent.h"
#import "THTextITConnectionController.h"
#import "THTabbarViewController.h"
#import "THPaletteViewController.h"
#import "THCustomComponentEditable.h"

@implementation THDirector

#pragma mark - Singleton

static THDirector * _sharedInstance = nil;

+(THDirector*)sharedDirector {
    @synchronized([THDirector class]){
        if (!_sharedInstance)
            _sharedInstance = [[THDirector alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

+(id)alloc {
    @synchronized([THDirector class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    
    return nil;
}

-(void) preload{
    [[SimpleAudioEngine sharedEngine] preloadEffect:kConnectionMadeEffect];
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadProjectProxies];
        
        //server
        self.serverController = [[THServerController alloc] init];
        self.serverController.delegate = self;
        [self.serverController startServer];
        
        //textIT client
        self.textITClientController = [[THTextITConnectionController alloc] init];
        self.textITClientController.delegate = self;
        [self.textITClientController startClient];
        
        //self.javascriptRunner = [[THJavascriptRunner alloc] init];
        
        [self loadCustomComponents];
        
        [self preload];
        
    }
    return self;
}

#pragma mark - Methods

-(NSMutableArray*) loadProjectProxies {
    
    if([TFFileUtils dataFile:kProjectProxiesFileName existsInDirectory:@""]){
        NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
        self.projectProxies = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        //NSLog(@"%@",filePath);
        //[self printProjects];
    } else {
        self.projectProxies = [NSMutableArray array];
    }
    
    return self.projectProxies;
}
/*
-(void) printProjects{
    for (THProjectProxy * proxy in self.projectProxies) {
        NSLog(@"%@",proxy.name);
    }
}*/

-(NSMutableArray*) loadCustomComponents {
    
    if([TFFileUtils dataFile:kCustomComponentsFileName existsInDirectory:@""]){
        NSString *filePath = [TFFileUtils dataFile:kCustomComponentsFileName inDirectory:@""];
        self.customComponents = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.customComponents = [NSMutableArray array];
    }
    
    /*
    THCustomComponent * customComponent = [[THCustomComponent alloc] init];
    customComponent.name = @"runningSpeed";
    [self.customComponents addObject:customComponent];
    [self saveCustomComponents];*/
    
    return self.customComponents;
}

-(void) saveProjectProxies{
    //[self printProjects];
    
    NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
    [NSKeyedArchiver archiveRootObject:self.projectProxies toFile:filePath];
}

-(void) saveCustomComponents{
    
    NSString *filePath = [TFFileUtils dataFile:kCustomComponentsFileName inDirectory:@""];
    [NSKeyedArchiver archiveRootObject:self.customComponents toFile:filePath];
}

#pragma mark - Layer

-(TFLayer*) currentLayer{
    return self.projectController.currentLayer;
}

#pragma Mark - Server Delegate

-(void) server:(THServerController*)controller peerConnected:(NSString*)peerName {
    [[SimpleAudioEngine sharedEngine] playEffect:@"peer_connected.mp3"];
    [self.projectController updatePushButtonState];
}

-(void) server:(THServerController*)controller peerDisconnected:(NSString*)peerName {
    [[SimpleAudioEngine sharedEngine] playEffect:@"peer_disconnected.mp3"];
    [self.projectController updatePushButtonState];
}

-(void) server:(THServerController*)controller isReadyForSceneTransfer:(BOOL)ready {
    [self.projectController updatePushButtonState];
}

-(void) server:(THServerController*)controller isTransferring:(BOOL)transferring {
    /*
     UIImage * image;
     if(transferring){
     image = [UIImage imageNamed:@"server_busy"];
     }else{
     image = [UIImage imageNamed:@"server_online"];
     }
     wirelessButton.image = image;*/
}

- (void) server:(THServerController*)controller isRunning:(BOOL)running{
    //[self updateWirelessButtonTo:running];
}


#pragma Mark - Client Delegate

-(BOOL) doesComponentExistWithName:(NSString*) name{
    return ([self idxOfSoftwareComponentWithName:name] >= self.customComponents.count);
}

-(NSInteger) idxOfSoftwareComponentWithName:(NSString*) name{
    NSInteger idx = 0;
    for (THCustomComponent * component in self.customComponents) {
        if([component.name isEqualToString:name]){
            return idx;
        }
        idx++;
    }
    return idx;
}

-(THCustomComponent*) softwareComponentWithName:(NSString*) name{
    NSInteger idx = [self idxOfSoftwareComponentWithName:name];
    if(idx < self.customComponents.count){
        return [self.customComponents objectAtIndex:idx];
    }
    return nil;
}

-(void) didStartReceivingProjectNamed:(NSString*) name{
    NSLog(@"received project: %@",name);
}

-(void) didMakeProgressForCurrentProject:(float) progress{
    NSLog(@"%f",progress);
}

-(void) didFinishReceivingObject:(THCustomComponent*) component{
    
    NSLog(@"received object: %@",component);
    
    NSInteger idx = [self idxOfSoftwareComponentWithName:component.name];

    if(idx < self.customComponents.count){
        [self.customComponents replaceObjectAtIndex:idx withObject:component];
    } else {
        [self.customComponents addObject:component];
    }
    
    [self.projectController.tabController.paletteController reloadCustomProgrammingObjects];
}

-(void) appendStatusMessage:(NSString*) msg{
    NSLog(@"%@",msg);
}

@end
