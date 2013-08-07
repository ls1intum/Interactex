//
//  THClientScene.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THClientRealScene.h"
#import "THClientAppDelegate.h"
#import "THSimulableWorldController.h"

@implementation THClientRealScene

@dynamic image;

-(id)initWithName:(NSString*)newName world:(THClientProject*) project {
    if(self = [super init]){
        archiveFilename = newName;
        _name = newName;
        _project = project;
    }
    return self;
}

-(id)initWithArchive:(NSString*)anArchiveFile {
    if(self = [super init]){
        archiveFilename = anArchiveFile;
        _name = anArchiveFile;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    //NSString *newName = [THClientScene resolveNameConflictFor:[decoder decodeObjectForKey:@"name"]];
    _name = [decoder decodeObjectForKey:@"name"];
    archiveFilename = _name;
    _project = [decoder decodeObjectForKey:@"project"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_project forKey:@"project"];
}

#pragma mark - Properties

-(UIImage *)image {
    NSString *screenshotFile = [archiveFilename stringByAppendingString:@".png"];
    NSString *screenshotPath = [TFFileUtils dataFile:screenshotFile
                                                   inDirectory:kProjectImagesDirectory];
    if([TFFileUtils dataFile:screenshotFile existsInDirectory:kProjectImagesDirectory])
        return [UIImage imageWithContentsOfFile:screenshotPath];
    return [UIImage imageNamed:@"screenMissing.png"];
}

#pragma mark - Save/Load

-(void)save {
    NSString *filePath = [TFFileUtils dataFile:archiveFilename
                                             inDirectory:kProjectsDirectory];
    [TFFileUtils deleteDataFile:archiveFilename
                            fromDirectory:kProjectsDirectory];
    
    THClientProject * project = [THSimulableWorldController sharedInstance].currentProject;
    [NSKeyedArchiver archiveRootObject:project toFile:filePath];
}

-(void)saveWithImage:(UIImage*)image {
    if(!self.isFakeScene){
        
        NSString *screenshotFile = [archiveFilename stringByAppendingString:@".png"];
        NSString *screenshotPath = [TFFileUtils dataFile:screenshotFile inDirectory:kProjectImagesDirectory];
        
        [TFFileUtils saveImageToFile:image file:screenshotPath];
        [self save];
    }
}

-(void)loadFromArchive {
    if([TFFileUtils dataFile:archiveFilename existsInDirectory:kProjectsDirectory]){
        // Load the worlds state from disk
        
        NSString *filePath = [TFFileUtils dataFile:archiveFilename inDirectory:kProjectsDirectory];
        _project = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else{
        [[THSimulableWorldController sharedInstance] newProject];
    }
}

-(void)unload {
    _project = nil;
    [THSimulableWorldController sharedInstance].currentProject = nil;
}

#pragma mark - File Management

-(void)deleteArchive {
    NSString *screenshotFile = [archiveFilename stringByAppendingString:@".png"];
    [TFFileUtils deleteDataFile:archiveFilename fromDirectory:kProjectsDirectory];
    [TFFileUtils deleteDataFile:screenshotFile fromDirectory:kProjectImagesDirectory];
}

-(void)renameTo:(NSString*)newName {
    newName = [THClientRealScene resolveNameConflictFor:newName];
    NSString *screenshotFile = [archiveFilename stringByAppendingString:@".png"];
    NSString *newScreenshotFile = [newName stringByAppendingString:@".png"];
    [TFFileUtils renameDataFile:archiveFilename to:newName inDirectory:kProjectsDirectory];
    [TFFileUtils renameDataFile:screenshotFile  to:newScreenshotFile inDirectory:kProjectImagesDirectory];
    archiveFilename = newName;
}

#pragma mark - Class Methods

+(NSMutableArray*)persistentScenes {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *archivesDirectory = [TFFileUtils dataDirectory:kProjectsDirectory];
    NSArray *sceneFiles = [fm contentsOfDirectoryAtPath:archivesDirectory error:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSString *archivePath in sceneFiles){
        THClientRealScene *scene = [[THClientRealScene alloc] initWithArchive:[archivePath lastPathComponent]];
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
