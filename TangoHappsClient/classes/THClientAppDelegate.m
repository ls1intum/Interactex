/*
THClientAppDelegate.m
Interactex Client

Created by Juan Haladjian on 24/09/2012.

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

#import "THClientAppDelegate.h"
#import "THClientScene.h"
#import "THClientProjectProxy.h"
#import "THClientConnectionController.h"

@implementation THClientAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if([TFFileUtils dataFile:kProjectProxiesFileName existsInDirectory:@""]){
        
        NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
        self.projectProxies = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
    } else {
        
        self.projectProxies = [NSMutableArray array];
        
    }
    
    self.connectionController = [[THClientConnectionController alloc] init];
    
    //[self generateRandomScenes];
    
    // Override point for customization after application launch.
    return YES;
}

-(void) saveProjectProxies{
    
    NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
    [NSKeyedArchiver archiveRootObject:self.projectProxies toFile:filePath];
}

-(void) generateRandomScenes{
    
    for (int i = 0; i < 7; i ++) {
        NSString * name = [NSString stringWithFormat:@"halloProject %d",i];
        THClientProject * project = [[THClientProject alloc] initWithName:name];
        [project save];
        
        THClientProjectProxy * proxy = [THClientProjectProxy proxyWithName:name];
        [self.projectProxies addObject:proxy];
    }
    
    [self saveProjectProxies];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    [THClientScene persistScenes:self.projectProxies];
    
    [self.connectionController stopClient];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self.connectionController startClient];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //[THClientScene persistScenes:self.scenes];
}

@end
