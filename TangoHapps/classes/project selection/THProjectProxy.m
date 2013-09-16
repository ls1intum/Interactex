//
//  TFProjectProxy.m
//  Tango
//
//  Created by Juan Haladjian on 12/1/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProjectProxy.h"

@implementation THProjectProxy

#pragma mark - Construction

+(id) proxyWithName:(NSString*) name{
    return [[THProjectProxy alloc] initWithName:name];
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
        
        NSString * imageFile = [self.name stringByAppendingString:@".png"];
        NSString * imagePath = [TFFileUtils dataFile:imageFile
                                             inDirectory:kProjectImagesDirectory];
        if([TFFileUtils dataFile:imageFile existsInDirectory:kProjectImagesDirectory])
            self.image = [UIImage imageWithContentsOfFile:imagePath];
        
        self.date = [NSDate date];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.date = [decoder decodeObjectForKey:@"date"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.date forKey:@"date"];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone{
    THProjectProxy * proxy = [[THProjectProxy alloc] initWithName:self.name];
    proxy.image = self.image;
    return proxy;
}

@end
