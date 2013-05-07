//
//  THAsset.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/26/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THAsset.h"


@implementation THAssetDescription

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        self.type = [decoder decodeIntegerForKey:@"type"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.fileName forKey:@"fileName"];
    [coder encodeInteger:self.type forKey:@"type"];
}

@end

@implementation THAsset

@dynamic type;
@dynamic fileName;

#pragma mark - Archiving

-(id) init{
    self = [super init];
    if(self){
        _assetDescription = [[THAssetDescription alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self){
        self.assetDescription = [decoder decodeObjectForKey:@"assetDescription"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.assetDescription forKey:@"assetDescription"];
}

#pragma mark - Methods

-(void) setType:(THAssetType)type{
    self.assetDescription.type = type;
}

-(void) setFileName:(NSString *)fileName{
    self.assetDescription.fileName = fileName;
}

-(THAssetType) type{
    return self.assetDescription.type;
}

-(NSString*) fileName{
    return self.assetDescription.fileName;
}

-(void) save{
    
}

@end
