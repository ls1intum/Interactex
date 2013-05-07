//
//  THAssetCollection.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/26/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THSoundAsset;
@class THImageAsset;

@interface THAssetCollection : NSObject <NSCoding>
{
    
}

@property (nonatomic, strong) NSMutableArray * sounds;
@property (nonatomic, strong) NSMutableArray * images;
@property (nonatomic, readonly) NSArray * assets;

+(void) importAssets:(NSArray*) assets;
+(NSArray*) assetDescriptionsWithMissingAssetsIn:(NSArray*) array;
-(NSArray*) assetDescriptions;

-(id) initWithLocalFiles;

-(void) addSoundAsset:(THSoundAsset*) asset;
-(void) addImageAsset:(THImageAsset*) asset;

@end
