//
//  THClientScene.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClientProject;

@interface THClientRealScene : NSObject {
    NSString *archiveFilename;
}

@property (readonly) NSString *name;
@property (nonatomic, readonly) UIImage * image;
@property (nonatomic, readonly) THClientProject * project;
@property (nonatomic) BOOL isFakeScene;

+(NSString*)resolveNameConflictFor:(NSString*)name;
+(NSMutableArray*)persistentScenes;

-(id)initWithName:(NSString*)newName world:(THClientProject*) world;
-(id)initWithArchive:(NSString*)archiveFile;

-(void) save;
-(void) saveWithImage:(UIImage*)image;
-(void) loadFromArchive;
-(void) unload;
-(void) deleteArchive;
-(void) renameTo:(NSString*)newName;

@end