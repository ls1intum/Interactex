//
//  THClientScene.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/25/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClientProject;

@interface THClientScene : NSObject <NSCoding, NSCopying> {
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic) UIImage * image;
@property (nonatomic, strong) THClientProject * project;
@property (nonatomic) BOOL isFakeScene;
@property (nonatomic, readonly) BOOL isSaved;

+(NSString*) resolveNameConflictFor:(NSString*)name;
+(NSMutableArray*) persistentScenes;
+(void) persistScenes:(NSMutableArray*) scenes;

+(void) deleteSceneNamed:(NSString*) sceneName;
+(BOOL) sceneExists:(NSString*) sceneName;

-(id) initWithName:(NSString*)newName world:(THClientProject*) world;
-(id) initWithName:(NSString*) aName;

//saving
-(void) save;
-(void) saveWithImage:(UIImage*)image;
-(void) saveImage:(UIImage*) image;
-(void) loadFromArchive;
-(void) deleteArchive;
-(void) renameTo:(NSString*)newName;

@end