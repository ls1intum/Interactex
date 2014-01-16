/*
THClientScene.m
Interactex Client

Created by Juan Haladjian on 25/09/2012.

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

#import "THClientScene.h"
#import "THClientAppDelegate.h"
#import "THSimulableWorldController.h"

@implementation THClientScene

@dynamic image;

#pragma mark - Class Methods

+(NSMutableArray*) persistentScenes {
    
    NSString * fileName = [TFFileUtils dataFile:@"scenes" inDirectory:@""];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    return [NSMutableArray arrayWithArray:array];
}

+(void) persistScenes:(NSMutableArray*) scenes {
    
    NSString * fileName = [TFFileUtils dataFile:@"scenes" inDirectory:@""];
    [NSKeyedArchiver archiveRootObject:scenes toFile:fileName];
}

+(NSString*)resolveNameConflictFor:(NSString*)conflictingName {
    NSUInteger counter = 2;
    NSString *name = conflictingName;
    while ([TFFileUtils dataFile:name existsInDirectory:kProjectsDirectory]) {
        name = [conflictingName stringByAppendingFormat:@" %i", counter];
        counter++;
    }
    return name;
}

+(BOOL) sceneExists:(NSString*) sceneName{
    return [TFFileUtils dataFile:sceneName existsInDirectory:kProjectsDirectory];
}

+(void) deleteSceneNamed:(NSString*) sceneName{
    
    NSString *screenshotFile = [sceneName stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:sceneName fromDirectory:kProjectsDirectory];
    [TFFileUtils deleteDataFile:screenshotFile fromDirectory:kProjectImagesDirectory];
}

#pragma mark - Initialization

-(id)initWithName:(NSString*) aName {
    self = [super init];
    if(self){
        self.name = aName;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    //NSString *newName = [THClientScene resolveNameConflictFor:[decoder decodeObjectForKey:@"name"]];
    _name = [decoder decodeObjectForKey:@"name"];
    //_project = [decoder decodeObjectForKey:@"project"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    //[coder encodeObject:_project forKey:@"project"];
}

-(id)copyWithZone:(NSZone *)zone{
    //THClientProject * projectCopy = [self.project copy];
    
    //THClientScene * copy = [[THClientScene alloc] initWithName:self.name world: projectCopy];
    THClientScene * copy = [[THClientScene alloc] initWithName:self.name];
    
    copy.image = [self.image copy];
    copy.isFakeScene = self.isFakeScene;
    
    return copy;
}

#pragma mark - Properties

-(UIImage *)image {
    NSString *screenshotFile = [self.name stringByAppendingString:@".png"];
    NSString *screenshotPath = [TFFileUtils dataFile:screenshotFile inDirectory:kProjectImagesDirectory];
    if([TFFileUtils dataFile:screenshotFile existsInDirectory:kProjectImagesDirectory])
        return [UIImage imageWithContentsOfFile:screenshotPath];
    return [UIImage imageNamed:@"screenMissing.png"];
}

#pragma mark - Save/Load

-(BOOL) isSaved{
    return [THClientScene sceneExists:self.name];
}
/*
-(void) save {
    if([self isSaved]){
        [self deleteArchive];
    }
    
    NSString *filePath = [TFFileUtils dataFile:self.name inDirectory:kProjectsDirectory];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self.project toFile:filePath];
    if(!success){
        NSLog(@"failed to save object at path: %@",filePath);
    }
}*/

-(void) saveImage:(UIImage*) image{
    
    NSString *screenshotFile = [self.name stringByAppendingString:@".png"];
    NSString *screenshotPath = [TFFileUtils dataFile:screenshotFile inDirectory:kProjectImagesDirectory];
    
    [TFFileUtils saveImageToFile:image file:screenshotPath];
}

-(void)saveWithImage:(UIImage*)image {
    if(!self.isFakeScene){
        [self saveImage:image];
        //[self save];
    }
}

-(void)loadFromArchive {
    if([TFFileUtils dataFile:self.name existsInDirectory:kProjectsDirectory]){
        
       // NSString *filePath = [TFFileUtils dataFile:self.name inDirectory:kProjectsDirectory];
        //_project = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else{
        [[THSimulableWorldController sharedInstance] newProject];
    }
}

#pragma mark - File Management

-(void) deleteArchive {
    [THClientScene deleteSceneNamed:self.name];
}

-(void)renameTo:(NSString*)newName {
    newName = [THClientScene resolveNameConflictFor:newName];
    NSString *screenshotFile = [self.name stringByAppendingString:@".png"];
    NSString *newScreenshotFile = [newName stringByAppendingString:@".png"];
    [TFFileUtils renameDataFile:self.name to:newName inDirectory:kProjectsDirectory];
    [TFFileUtils renameDataFile:screenshotFile  to:newScreenshotFile inDirectory:kProjectImagesDirectory];
    self.name = newName;
}

#pragma mark - Other

-(void) prepareToDie{
    //_project = nil;
}

@end
