//
//  THClientFakeSceneDataSource.h
//  TangoHapps
//
//  Created by Juan Haladjian on 3/20/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDigitalOutputSceneName;
extern NSString * const kDigitalInputSceneName;
extern NSString * const kBuzzerSceneName;
extern NSString * const kAnalogOutputSceneName;
extern NSString * const kAnalogInputSceneName;
extern NSString * const kCompassSceneName;

@interface THClientPresetsGenerator : NSObject
{
}

-(NSInteger) numFakeScenes;

@property(nonatomic, readonly) NSMutableArray * scenes;

-(THClientProject*) projectNamed:(NSString*) name;

@end
