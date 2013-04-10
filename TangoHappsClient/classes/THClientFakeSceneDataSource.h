//
//  THClientFakeSceneDataSource.h
//  TangoHapps
//
//  Created by Juan Haladjian on 3/20/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THClientFakeSceneDataSource : NSObject
{
}

-(NSMutableArray*) fakeScenes;
-(NSInteger) numFakeScenes;

@property(nonatomic, readonly) NSMutableArray * fakeScenes;

@end
