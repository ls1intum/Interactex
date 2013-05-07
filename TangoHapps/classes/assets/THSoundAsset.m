//
//  THSoundAsset.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/26/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSoundAsset.h"

@implementation THSoundAsset

-(id) init{
    self = [super init];
    if(self){
        self.type = kAssetTypeSound;
    }
    return self;
}

-(void) save{
    NSLog(@"saving sound: %@",self.fileName);
}

@end
