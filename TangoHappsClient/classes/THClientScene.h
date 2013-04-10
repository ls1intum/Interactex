//
//  THClientScene.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClientProject;

@interface THClientScene : NSObject
{
    NSString *archiveFilename;
}

@property (readonly) NSString *name;
@property (nonatomic, readonly) UIImage * screenshot;
@property (nonatomic, readonly) THClientProject * project;
@property (nonatomic) BOOL fakeScene;

+(NSString*)resolveNameConflictFor:(NSString*)name;

-(id)initWithName:(NSString*)newName world:(THClientProject*) world;
-(id)initWithArchive:(NSString*)archiveFile;

// Manage archiving
-(void)save;
-(void)saveWithImage:(UIImage*)image;
-(void)loadFromArchive;
-(void)unload;
-(void)deleteArchive;
//-(void)stash;
//-(void)unstash;
-(void)renameTo:(NSString*)newName;

+(NSMutableArray*)persistentScenes;

@end