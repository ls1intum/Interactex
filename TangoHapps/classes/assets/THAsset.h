//
//  THAsset.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/26/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kAssetTypeSound,
    kAssetTypeImage
} THAssetType;

@interface THAssetDescription : NSObject <NSCoding>
{
    
}

@property (nonatomic) THAssetType type;
@property (nonatomic, copy) NSString * fileName;

@end

@interface THAsset : NSObject <NSCoding>
{
    
}

@property (nonatomic) THAssetDescription * assetDescription;
@property (nonatomic) THAssetType type;
@property (nonatomic) NSString * fileName;

-(void) save;

@end
