//
//  THAssetCollection.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/26/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THAssetCollection.h"
#import "THSoundAsset.h"

@implementation THAssetCollection

#pragma mark - Init

-(id) initWithLocalFiles{
    self = [super init];
    if(self){
        
        _sounds = [NSMutableArray array];
        _images = [NSMutableArray array];
        
        [self loadSounds];
        [self loadImages];
        
    }
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        _sounds = [NSMutableArray array];
        _images = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        self.sounds = [decoder decodeObjectForKey:@"sounds"];
        self.images = [decoder decodeObjectForKey:@"images"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.sounds forKey:@"sounds"];
    [coder encodeObject:self.images forKey:@"images"];
}

#pragma mark - Methods

+(NSArray*) localSoundFiles{
    NSArray * soundFiles = [TFFileUtils filesInDirectory:@"sounds"];
    return soundFiles;
}

+(NSArray*) localImageFiles{
    NSArray * imageFiles = [TFFileUtils filesInDirectory:@"sounds"];
    return imageFiles;
}

-(void) loadSounds{
    NSArray * sounds = [THAssetCollection localSoundFiles];
    for (NSString * soundName in sounds) {
        THSoundAsset * asset = [[THSoundAsset alloc] init];
        asset.fileName = soundName;
        [_sounds addObject:asset];
    }
}

-(void) loadImages{/*
    NSArray * sounds = [TFFileUtils filesInDirectory:@"sounds"];
    for (NSString * soundName in sounds) {
        THSoundAsset * asset = [[THSoundAsset alloc] init];
        asset.fileName = soundName;
        [_images addObject:asset];
    }*/
}

-(NSArray*) assets{
    return [NSArray arrayWithArray:_sounds];
}

+(NSArray*) assetDescriptionsWithMissingAssetsIn:(NSArray*) array{
    NSMutableArray * assetDescriptions = [[NSMutableArray alloc] init];
    
    NSArray * soundFiles = [THAssetCollection localSoundFiles];

    NSMutableSet * set = [NSMutableSet setWithCapacity:soundFiles.count];
    for (NSString * soundName in soundFiles) {
        [set setValue:nil forKey:soundName];
    }
    
    for (THSoundAsset * asset in array) {
        if(![set containsObject:asset.fileName]){
            THAssetDescription * assetDescription = [[THAssetDescription alloc] init];
            assetDescription.type = kAssetTypeSound;
            assetDescription.fileName = asset.fileName;
            [assetDescriptions addObject:assetDescription];
        }
    }
    
    return assetDescriptions;
}

-(NSArray*) assetDescriptions{
    
    NSArray * assets = self.assets;
    NSMutableArray * descriptions = [NSMutableArray arrayWithCapacity:assets.count];
    for (THAsset * asset in assets) {
        [descriptions addObject:asset.assetDescription];
    }
    return descriptions;
}

+(void) importAssets:(NSArray*) assets{
    for (THAsset * asset in assets) {
        [asset save];
    }
}

-(void) addSoundAsset:(THSoundAsset*) asset{
    [_sounds addObject:asset];
}

-(void) addImageAsset:(THImageAsset*) asset{
    [_images addObject:asset];
}

@end
