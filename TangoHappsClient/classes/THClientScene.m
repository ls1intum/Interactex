//
//  THClientScene.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientScene.h"
#import "THClientAppDelegate.h"
#import "THSimulableWorldController.h"

@implementation THClientScene

@dynamic image;

-(id)initWithName:(NSString*)newName world:(THClientProject*) project {
    if(self = [super init]){
        _name = newName;
        _project = project;
    }
    return self;
}

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
    _project = [decoder decodeObjectForKey:@"project"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_project forKey:@"project"];
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

-(void) save {
    if([self isSaved]){
        [self deleteArchive];
    }
    
    NSString *filePath = [TFFileUtils dataFile:self.name inDirectory:kProjectsDirectory];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self.project toFile:filePath];
    if(!success){
        NSLog(@"failed to save object at path: %@",filePath);
    }
}

-(void) saveImage:(UIImage*) image{
    
    NSString *screenshotFile = [self.name stringByAppendingString:@".png"];
    NSString *screenshotPath = [TFFileUtils dataFile:screenshotFile inDirectory:kProjectImagesDirectory];
    
    [TFFileUtils saveImageToFile:image file:screenshotPath];
}

-(void)saveWithImage:(UIImage*)image {
    if(!self.isFakeScene){
        [self saveImage:image];
        [self save];
    }
}

-(void)loadFromArchive {
    if([TFFileUtils dataFile:self.name existsInDirectory:kProjectsDirectory]){
        
        NSString *filePath = [TFFileUtils dataFile:self.name inDirectory:kProjectsDirectory];
        _project = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else{
        [[THSimulableWorldController sharedInstance] newProject];
    }
}

#pragma mark - File Management

+(BOOL) sceneExists:(NSString*) sceneName{
    return [TFFileUtils dataFile:sceneName existsInDirectory:kProjectsDirectory];
}

+(void) deleteSceneNamed:(NSString*) sceneName{
    
    NSString *screenshotFile = [sceneName stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:sceneName fromDirectory:kProjectsDirectory];
    [TFFileUtils deleteDataFile:screenshotFile fromDirectory:kProjectImagesDirectory];
}

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

#pragma mark - Class Methods

+(NSMutableArray*)persistentScenes {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *archivesDirectory = [TFFileUtils dataDirectory:kProjectsDirectory];
    NSArray *sceneFiles = [fm contentsOfDirectoryAtPath:archivesDirectory error:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSString *archivePath in sceneFiles){
        THClientScene *scene = [[THClientScene alloc] initWithName:[archivePath lastPathComponent]];
        [array addObject:scene];
    }
    return array;
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

-(void) prepareToDie{
    _project = nil;
}

@end
