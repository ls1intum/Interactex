//
//  TFProjectProxy.h
//  Tango
//
//  Created by Juan Haladjian on 12/1/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THProjectProxy : NSObject

@property (nonatomic) NSString * name;
@property (nonatomic) UIImage * image;

+(id) proxyWithName:(NSString*) name;
-(id) initWithName:(NSString*) name;

@end
